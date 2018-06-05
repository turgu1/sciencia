namespace :ruby_lang do
  
  desc 'Install Ruby and the Bundler gem'

  task :install do

    on roles :app do |host|

      ruby_version = fetch(:rbenv_ruby)
      bundler_version = fetch(:rbenv_bundler)

      unless test "[ -d .rbenv/versions/#{ruby_version} ]"

        puts "-----> Installing ruby version #{ruby_version}:"

        execute "rm -rf ~/tmp"
        execute "mkdir ~/tmp"

        upload! "#{fetch(:rails_root)}/src/ruby-#{ruby_version}.tar.gz",    "tmp/ruby.tar.gz"
        upload! "#{fetch(:rails_root)}/src/bundler-#{bundler_version}.gem", "tmp/bundler.gem"

        within "~/tmp" do
          execute :tar, "zxf ruby.tar.gz"
        end

        within "~/tmp/ruby-#{ruby_version}" do
          execute :bash, "./configure --prefix=$HOME/.rbenv/versions/#{ruby_version}"
          execute :make
          execute :make, "install"
        end

        execute ".rbenv/versions/#{ruby_version}/bin/gem", "install --force --local tmp/bundler.gem"
        execute "rm -rf ~/tmp"

        execute ".rbenv/bin/rbenv global #{ruby_version}"
      end
    end
  end

  before 'setup', 'ruby_lang:install'

  task :set_version do

    on roles :app do |host|

      ruby_version = fetch(:rbenv_ruby)
      
      within release_path do

        unless test *%W{[ -f '.ruby-version' ]}
          execute *%W[~/.rbenv/bin/rbenv local '#{ruby_version}']
        end

      end
    end
  end

  after 'deploy:updating', 'ruby_lang:set_version'
end
