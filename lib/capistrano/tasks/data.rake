namespace :data do
  
  desc "Retrieve database entries from already running app"

  task :retrieve do

    on roles :all do |host|

      main_tar_file  = "#{fetch(:application)}_data.tar"
      src_data_file  = "#{fetch(:rails_root)}/#{main_tar_file}"
      psql_file      = "#{fetch(:application)}.psql"
      data_files_tar = "data_files.tar"

      if File.exists?(src_data_file)

        within release_path do
          puts "-----> Synchronizing database schema with current system in production:"
          
          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:migrate VERSION=20131015182741'
          end
        end

        execute "rm -rf ~/tmp"
        execute "mkdir ~/tmp"

        within "./tmp" do

          upload! src_data_file, "#{main_tar_file}"

          if test *%W{[ -f './#{main_tar_file}' ]}
          
            execute :tar, "xf ./#{main_tar_file}"

            within "./#{fetch(:application)}_data" do

              if test *%W{[ -f './#{psql_file}' ]}
                puts "-----> Retrieving database tables from current system in production:"
                execute :sudo, "-u postgres psql -d #{fetch(:pg_database)} < ./#{psql_file}"
              else
                puts "--> Warning: File ./#{psql_file} not found"
                execute :pwd
              end

              if test *%W{[ -f './#{data_files_tar}' ]}
                puts "-----> Retrieving data files in shared/system/data:"
                execute :bash, *%W[-c ' ( cat './#{data_files_tar}' | ( cd '#{shared_path}' ; tar xf - ) ) ']
              else
                puts "--> Warning: File ./#{data_files_tar} not found"
                execute :pwd
              end
            end
          else
            puts "--> Warning: File ./#{main_tar_file} not found"
            execute :pwd
          end
        end

        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:migrate'
          end
        end

        #execute "rm -rf ~/tmp"
        File.delete(src_data_file)

      end
    end
  end

  before "carrierwave:symlink", "data:retrieve"
end