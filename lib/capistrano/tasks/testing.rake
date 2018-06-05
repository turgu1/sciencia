def sudo_file_exists?(path)
   sudo "[ -e #{path} ]"
end

namespace :testing do
  desc "Some tests..."

  task :exec do

    on roles :all do |host|

      execute :pwd

      execute :mkdir, '-p', 'toto'

      within "./toto" do

        execute :touch, "allo"

        execute :ls

        the_file = "allo"

        if sudo_file_exists?("/etc/ssl/private/toto")
          puts "Found!"
        else
          puts "Not found!"
        end

      end
    end
  end
end