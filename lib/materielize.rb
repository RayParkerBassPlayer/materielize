require "materielize/version"

module Materielize
  class ConfigFiles
    class << self
      def root_dir
        "materiel"
      end

      def default_config_directory
        "default_config_files"
      end

      def materiel_exists?
        Dir.exists?(root_dir)
      end

      def default_config_dir_exists?
        Dir.exists?(File.join(root_dir, default_config_directory))
      end

      def init_cfg_files
        @rails_root = File.expand_path(".")
        @template_dir = File.expand_path("materiel/default_config_files")

        puts
        puts "Copying default configuration files..."
        copy @template_dir
        puts
        puts "Config files copied.  Edit things as you see fit. All original files can be found in 'materiel/default_config_files'"
        puts
      end
    end


    private

    # ====================================================================================================================================================================
    # = Recursive call that winds through the materiel directory and copies default files.  Starting at materiel/default_config_files, the dir structure mimics the app  =
    # ====================================================================================================================================================================

    def copy dir
      old_dir = Dir.getwd

      Dir.chdir(dir)
      cwd = Dir.getwd

      target_dir = @rails_root + cwd.gsub(@template_dir, "")

      for entry in Dir.entries(".") do
        next if entry == "." || entry == ".."

        if File.directory?(entry)
          copy entry
        else
          target_file = "#{target_dir}/#{entry}"

          # TODO: Get rid of the forced deletion of existing files when we're offen rake 0.8.7
          # In the current test environment, rake 0.8.7 is locked.  Passing the --force option to the thor task
          # bubbles through to rake and it chokes on the 'unknown' parameter. The only time this task is likely to
          # be run in the test environment is on the CI server, so just forcing it for now.
          if File.exists?("#{target_dir}/#{entry}") && (options[:force] || ENV["RAILS_ENV"] == "test")
            puts "#{target_file} exists, removing due to 'force' option..."
            FileUtils.rm(target_file)
          end

          if !File.exists?(target_file)
            puts "Creating #{entry}..."
            begin
              File.copy "#{cwd}/#{entry}", target_file
            rescue => e
              puts "Error copying file: #{e}"
            end
          else
            puts "#{entry} exists, skipping..."
          end
        end
      end

      Dir.chdir(old_dir)
    end
  end
end
