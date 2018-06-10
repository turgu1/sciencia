#!/bin/bash

app_name=$1
username=`cat apps/${app_name}/shared/config/database.yml | grep username: | grep -o '[[:alnum:]_]*$'`
psw=`cat apps/${app_name}/shared/config/database.yml | grep password: | grep -o '[^[:space:]]*$'`
db_name=`cat apps/${app_name}/shared/config/database.yml | grep database: | grep -o '[[:alnum:]_]*$'`

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

echo Done
