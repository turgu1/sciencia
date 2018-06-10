#!/bin/bash

# prepare user account to allow pg_dump without psw

app_name=$1

shared_path="/home/${app_name}/apps/${app_name}/shared"

username=`sudo cat ${shared_path}/config/database.yml | grep username: | grep -o '[[:alnum:]_]*$'`
psw=`sudo cat ${shared_path}/config/database.yml | grep password: | grep -o '[^[:space:]]*$'`
db_name=`sudo cat ${shared_path}/config/database.yml | grep database: | grep -o '[[:alnum:]_]*$'`

echo "username: ${username}"
echo "database: ${db_name}"

file=".pgpass"

if [ -e "$file" ]; then
  tmp=".tmp_file"
  while read -r line
  do
    [[ $line =~ ^.+:${db_name}:.+$ ]] && continue
    echo $line
  done < "$file" >"$tmp"
  mv $tmp $file
fi

psw=`sed -e 's/^"//' -e 's/"$//' <<< "$psw"`
echo "localhost:*:$db_name:$username:$psw" >> $file
chmod 600 $file

# retrieve data

folder_name="${app_name}_data"
main_tar_file="${folder_name}_old_production.tar.gz"
psql_file="${app_name}.psql"
database_name="${db_name}"
data_files_tar="data_files.tar"
migration_file="migration.txt"

rm -rf ~/tmp
mkdir ~/tmp

cd ~/tmp
mkdir "./${folder_name}"

cd "./${folder_name}"
pg_dump -h localhost "${database_name}" -U "${username}" --column-inserts --data-only > "${psql_file}"

if [ -d "${shared_path}/system/data" ]; then
  sudo bash -c "( cd ${shared_path} ; tar cf - system/data ) > ${data_files_tar}"
fi

mig_nbr=`sudo -u postgres psql -t -d ${database_name} -c 'SELECT version from schema_migrations order by version desc limit 1 ;' | grep -o '[^[:space:]]*'`
echo "${mig_nbr}" > ${migration_file}

cd ..
tar zcf "../${main_tar_file}" "${folder_name}"

cd ..
echo "Backup file created: ${main_tar_file}"
rm -rf ~/tmp

echo Done
