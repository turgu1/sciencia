# config valid for current version and patch releases of Capistrano
lock "~> 3.11"

set :application, "sciencia"

set :repo_url, -> { "file:///home/#{fetch(:app_user)}/#{fetch(:application)}.git" }

# sciencia location on the development station
set :rails_root,     "#{File.dirname(__FILE__)}/.."

# ----- rbenv -----

set :rbenv_type,     :user
set :rbenv_ruby,     "2.5.1"
set :rbenv_bundler,  "1.16.2"

set :rbenv_prefix,   "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles,    :all

# ----- bundler -----

set :bundle_flags, '--deployment --quiet --local'

# ----- postgresql -----

set :pg_username,                 "#{fetch(:application)}"
set :pg_database,                 "#{fetch(:application)}_production"
set :pg_extensions,               ["hstore"]
set :pg_env,                      "production"
set :pg_host,                     "localhost"
set :pg_generate_random_password, true

# ----- nginx and unicorn -----

set :nginx_server_ssl_ports,  [ 41777 ]
set :unicorn_use_tcp,         true
set :unicorn_tcp_listen_port, 41776

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

set :deploy_user,    -> { fetch(:app_user) }
set :deploy_to,      -> { "/home/#{fetch(:deploy_user)}/apps/#{fetch(:application)}" }

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

SSHKit.config.default_runner = :sequence
SSHKit.config.output_verbosity = Logger::DEBUG
