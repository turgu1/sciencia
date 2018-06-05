
def copy_permissions(reference, target)
  sudo "chmod --reference=#{reference} #{target}"
  sudo "chown --reference=#{reference} #{target}"
end

def copy_original_permissions(path)
  copy_permissions("#{path}.original", path)
end

def keep_original(path)
  # keep a copy of the original config file, and don't overwrite it once created
  path = capture("readlink -f #{path}").chomp if path.match(/^~/) # expand path if relative to home dir
  sudo "cp -p --no-clobber #{path} #{path}.original"
end

namespace :base do
  
  desc 'Install all dependencies on the server(s)'

  task :install do
    on roles(:all) do |host|

      host.user = host.properties.superuser

      unless test "[ -f ~/.base_installed ]"

        sudo "apt-get -y update"
        sudo "apt-get -y upgrade"

        # Generic tools for compiling and general app support
        sudo "apt-get -y install git net-tools openssl openssh-server curl gcc make postgresql-10 postgresql-server-dev-10 libssl-dev libreadline-dev zlib1g-dev nodejs nginx unzip"
        #build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion"

        # Specific tools required for spaceman
        sudo "apt-get -y install imagemagick libmagickwand-dev"

        keep_original '/etc/postgresql/10/main/postgresql.conf'

        execute "rm -rf ~/tmp"
        execute "mkdir ~/tmp"

        sudo "cp /etc/postgresql/10/main/postgresql.conf tmp/postgresql.conf"
        sudo "chmod 666 tmp/postgresql.conf"
        sudo %Q{echo "listen_addresses = '*'" >> tmp/postgresql.conf}
        sudo "cp tmp/postgresql.conf /etc/postgresql/10/main/postgresql.conf"

        copy_original_permissions "/etc/postgresql/10/main/postgresql.conf"

        execute "rm -rf ~/tmp"

        execute "touch ~/.base_installed"
      end
    end
  end
  before 'user_and_ssh_setup:install', 'base:install'
end

namespace :deploy do
  desc "Setup ENV variables"
  task :profile_env_vars do

    on roles :app do |host|

      unless test "[ -f .key_base_generated ]"
        execute %Q{echo "export SECRET_KEY_BASE=#{`rake secret`}" >> .bash_profile}
        execute "touch ~/.key_base_generated"
      end
    end
  end
end

# before "rbenv:validate"
# after "deploy:compile_assets", "deploy:deploy_env_vars"
