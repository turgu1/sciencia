namespace :app_code do

  desc "Upload the application source code"

  task :upload do

    on roles :app do |host|

      puts "-----> Uploading the application git"

      folder = "/home/#{fetch(:app_user)}/#{fetch(:application)}.git"

      execute "rm -rf #{folder}"
      execute "mkdir #{folder}"
      
      upload! './.git/', folder, recursive: true

    end
  end

  before 'git:check', 'app_code:upload'
end
