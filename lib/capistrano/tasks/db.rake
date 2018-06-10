namespace :db do

  desc "Retrieve a backup copy of the database and data files"
  task :backup do

    invoke 'db:prep'

    on roles :all do |host|

      tag            = Time.now.strftime("_%Y%m%d_%H%M%S")
      folder_name    = "#{fetch(:application)}_data"
      main_tar_file  = "#{folder_name}#{tag}.tar.gz"
      psql_file      = "#{fetch(:application)}.psql"
      database_name  = "#{fetch(:pg_database)}"
      data_files_tar = "data_files.tar"
      migration_file = "migration.txt"

      execute "rm -rf ~/tmp"
      execute "mkdir ~/tmp"

      within "./tmp" do
        execute :mkdir, "./#{folder_name}"

        within "./#{folder_name}" do
          execute *%W[pg_dump -h localhost #{database_name} -U #{fetch(:pg_username)} --column-inserts --data-only > #{psql_file}]

          if test "[ -d '#{shared_path}/system/data' ]"
            execute :bash, *%W[-c '( cd #{shared_path} ; tar cf - system/data ) > #{data_files_tar}']
          end

          mig_nbr = capture(*%W[sudo -u postgres psql -t -d #{database_name} -c 'SELECT version from schema_migrations order by version desc limit 1 ;' | grep -o '[^[:space:]]*'])
          execute *%W[echo '#{mig_nbr}' > #{migration_file}]
        end

        execute *%W[tar zcf #{main_tar_file} #{folder_name}]

        run_locally do
          if test "[ ! -d ../backups ]"
            execute "mkdir ../backups"
          end
        end

        download! "#{main_tar_file}", "../backups/#{main_tar_file}"

        puts "--> Backup file created: ../backups/#{main_tar_file}"
      end

      execute "rm -rf ~/tmp"
    end
  end

  desc "Restore database and datafiles."
  task :restore do

    on roles :all do |host|

      tar_name_start = "#{fetch(:application)}_data_"
      psql_file      = "#{fetch(:application)}.psql"
      data_files_tar = "data_files.tar"
      database_name  = "#{fetch(:pg_database)}" 
      owner          = "#{fetch(:pg_username)}"

      main_tar_file  = ""

      run_locally do
        main_tar_file  = capture(*%W[bash -c 'files=(#{tar_name_start}*); echo -n "${files[0]}"'])
      end

      if "#{main_tar_file}" != "#{tar_name_start}*"

        puts "-----------------------------------------------------------------------------------"
        puts "    Database backup file #{main_tar_file} is being restored..."
        puts "-----------------------------------------------------------------------------------"

        execute "rm -rf ~/tmp"
        execute "mkdir ~/tmp"

        within "./tmp" do

          upload! main_tar_file, main_tar_file

          if test *%W{[ -f './#{main_tar_file}' ]}
          
            execute :tar, "xf ./#{main_tar_file}"

            within "./#{fetch(:application)}_data" do

              if test *%W{[ -f migration.txt -a -f './#{psql_file}' ]}

                migration = capture(*%W[cat migration.txt])
                puts "--> Migration Version :#{migration}:"

                execute :sudo, "-u postgres psql -c 'DROP DATABASE #{database_name};'"
                execute :sudo, "-u postgres psql -c 'CREATE DATABASE #{database_name} WITH OWNER #{owner};'"
                execute :sudo, "-u postgres psql -d #{database_name} -c 'CREATE EXTENSION hstore;'"

                invoke 'db:migrating', migration

                execute :sudo, "-u postgres psql -d #{database_name} < ./#{psql_file}"

                invoke! 'db:migrating'

              else
                puts "--> Error: Files migration.txt and/or ./#{psql_file} not found"
                execute :pwd
              end

              if test *%W{[ -f './#{data_files_tar}' ]}
                puts "-----> Retrieving data files in shared/system/data:"
                execute :bash, *%W[-c ' cd '#{shared_path}' ; rm -rf system/data']
                execute :bash, *%W[-c ' ( cat './#{data_files_tar}' | ( cd '#{shared_path}' ; tar xf - ) ) ']
              else
                puts "--> Warning: File ./#{data_files_tar} not found"
                execute :pwd
              end
            end

            File.delete(main_tar_file)
          else
            puts "--> Warning: File ./#{main_tar_file} not found"
            execute :pwd
          end

        end
      else
        puts "--> No database restoration done. A file named #{tar_name_start}...tar.gz in current folder is required."
      end
    end
  end


  task :migrating, [:version] do |task, args|

    on roles :all do |host|
      within release_path do

        with rails_env: fetch(:rails_env) do
          if args.version.nil?
            execute *%W[rake db:migrate]
          else
            execute *%W[rake db:migrate VERSION=#{args.version}]
          end
        end
      end
    end
  end

  task :prep do

    on roles :all do |host|

      upload! "./src/prep-sec.sh", "prep-sec.sh"
      execute *%W[chmod 700 prep-sec.sh]
      execute *%W[bash -c './prep-sec.sh #{fetch(:application)}']
      execute *%W[rm prep-sec.sh]

    end
  end
end
