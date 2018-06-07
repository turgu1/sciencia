source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby                                '2.5.1'
gem 'rails',                        '5.2.0'

gem 'pg',                           '~> 1.0.0'
gem 'sass-rails',                   '~> 5.0'
gem 'uglifier',                     '>= 1.3.0'
gem 'coffee-rails',                 '~> 4.2'
gem 'jquery-rails',                 '~> 4.3.1'
gem 'jbuilder',                     '~> 2.5'
gem 'bootstrap-sass',               '~> 3.3.7'
gem 'bootstrap-datepicker-rails',   '~> 1.8.0.1'
gem 'font-awesome-rails',           '~> 4.7.0'
gem 'bootstrap-wysihtml5-rails',    '~> 0.3.3.8'
gem 'devise',                       '~> 4.4.3'
gem 'cancancan',                    '~> 2.1.3'
gem 'haml-rails',                   '~> 1.0.0'
gem 'simple_form',                  '~> 4.0.1'
gem 'cocoon',                       '~> 1.2.11'
gem 'jquery-datatables-rails',      '~> 3.4.0'
gem 'activemodel-serializers-xml',  '~> 1.0.2'
gem 'kaminari'         # data paging
gem 'counter_culture'  # counter cache management
gem 'carrierwave'      # file download
gem 'jquery-fileupload-rails'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri_19, :mri_20, :rbx]
  gem 'html2haml'
  gem 'listen',                     '>= 3.1.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen',      '~> 2.0.0'
  gem 'rails_layout'   # layout template generator
  gem 'capistrano',                 '~> 3.10',  require: false
  gem 'capistrano-bundler',         '~> 1.3',   require: false
  gem 'capistrano-rails',           '~> 1.3.1', require: false
  gem 'capistrano-rbenv',           '~> 2.1',   require: false
  gem 'capistrano-safe-deploy-to',  '~> 1.1.1', require: false
  gem 'capistrano-ssh-doctor',      '~> 1.0',   require: false
  gem 'capistrano-secrets-yml',     '~> 1.1.0', require: false
  gem 'sshkit-sudo'
  gem 'capistrano-unicorn-nginx',   '~> 5.2.0', require: false
  gem 'capistrano-postgresql',      '~> 5.0.1', require: false
end

group :development, :test do
  gem 'factory_bot_rails',          '~> 4.8.2', require: false
  gem 'rspec-rails'
  gem 'puma',                         '~> 3.11'
end

group :production do
  gem 'unicorn',                      '~> 5.4.0'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end
