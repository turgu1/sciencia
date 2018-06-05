# User setup and ssh parameters installation
# ------------------------------------------
#
# This script do the following tasks:
#
# 1) Create the user on the server and add it to sudoers without requiring password
#
# 2) Create users' key pair and the .ssh/authorized_keys2 file with developer public key
#
# 3) Create a .bash_profile to set RAILS_ENV and adjust the PATH
#
# 4) Lock password login for this user (only ssh login with key is allowed)
#

namespace :user_and_ssh_setup do
  
  desc 'Create user on server and proper authorization keys'

  task :install do

    on roles(:all) do |host|

      set :the_app_user, host.user
      set :the_app_user_password, "temp1234"

      host.user = host.properties.superuser

      # 1) Create the user on the server

      puts "-----> Creating user #{fetch(:the_app_user)} on server #{host}:"

      execute :sudo, "pwd"
      unless test "[ -d /home/#{fetch(:the_app_user)} ]"
        sudo "apt-get -y install build-essential openssl"
        sudo "useradd -s /bin/bash -m #{fetch(:the_app_user)} -p \`openssl passwd -1 '#{fetch(:the_app_user_password)}'\`"

        # Create sudoers entry
        execute "rm -rf ~/tmp"
        execute "mkdir ~/tmp"
        execute %Q{echo '#{fetch(:the_app_user)} ALL = (root) NOPASSWD: ALL' > ~/tmp/#{fetch(:the_app_user)}}
        execute %Q{echo '#{fetch(:the_app_user)} ALL = (postgres) NOPASSWD: ALL' >> ~/tmp/#{fetch(:the_app_user)}}
        sudo "mv ~/tmp/#{fetch(:the_app_user)} /etc/sudoers.d"
        sudo "chmod 440 /etc/sudoers.d/#{fetch(:the_app_user)}"
        sudo "chown root:root /etc/sudoers.d/#{fetch(:the_app_user)}"
        execute "rm -rf ~/tmp"
      end
    end

    on roles(:all) do |host|

      host.password = fetch(:the_app_user_password)

      # 2) Create the .ssh/authorized_keys2 file with developer public key

      unless test "[ -f .ssh/authorized_keys2 ]"
        puts "-----> Creating the .ssh/authorized_keys2 file with developer public key for #{host.user} on server #{host}:"

        execute "mkdir .ssh"
        execute "touch .ssh/authorized_keys2"

        upload!("#{ENV['HOME']}/.ssh/id_rsa.pub", 'key')

        execute "chmod 666 .ssh/authorized_keys2"
        execute "cat key >> .ssh/authorized_keys2"
        execute 'rm key'

        execute "chmod 600 .ssh/authorized_keys2"
        execute "chmod 700 .ssh"
      end

      unless test "[ -f .ssh/id_rsa ]"
        puts "-----> Creating rsa public/private key for #{host.user}"
        execute 'ssh-keygen -t rsa -N "" -f .ssh/id_rsa'
      end

      # 3) Create .bash_profile to run RAILS in production mode

      unless test "[ -f .bash_profile ]"
        execute %Q{echo 'if [ -f $HOME/.bashrc ]; then' >> .bash_profile}
        execute %Q{echo '  . $HOME/.bashrc' >>.bash_profile}
        execute %Q{echo 'fi' >>.bash_profile}
      end

      unless test 'source .bash_profile; [ $RAILS_ENV == production ]'
        puts "-----> Setting RAILS_ENV to 'production' for #{host.user}"
        execute %Q{echo 'export RAILS_ENV="production"' >> .bash_profile}
      end

      execute "chmod 700 .bash_profile"
    end

    # 4) Lock password for the app user

    on roles(:all) do |host|

      set :the_app_user, host.user

      host.user = host.properties.superuser


      puts "-----> Lock user #{fetch(:the_app_user)} password on server #{host}:"

      execute :sudo, "passwd -l #{fetch(:the_app_user)}"
    end

  end

  before 'rbenv:install', 'user_and_ssh_setup:install'
end
