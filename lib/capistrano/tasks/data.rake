namespace :data do

  desc "Retrieve database entries from backup tar file"
  task :retrieve do

    on roles :all do |host|

      run_locally do
        main_tar_file  = capture(*%W[bash -c 'files=(#{tar_name_start}*); echo -n "${files[0]}"'])
      end

      if "#{main_tar_file}" != "#{tar_name_start}*"

        invoke 'db:restore'

      end
    end
  end

  before "carrierwave:symlink", "data:retrieve"
end