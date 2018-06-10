# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
#require "capistrano/rbenv"
# require "capistrano/chruby"
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/unicorn_nginx'
require 'capistrano/postgresql'
#require 'capistrano/safe_deploy_to'
require 'capistrano/ssh_doctor'
require 'capistrano/secrets_yml'
require 'sshkit/sudo'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined

import 'lib/capistrano/tasks/carrierwave.rake'
import 'lib/capistrano/tasks/app_code.rake'
import 'lib/capistrano/tasks/ruby.rake'
import 'lib/capistrano/tasks/rbenv.rake'
import 'lib/capistrano/tasks/user_and_ssh_setup.rake'
import 'lib/capistrano/tasks/base.rake'
import 'lib/capistrano/tasks/data.rake'
import 'lib/capistrano/tasks/db.rake'
