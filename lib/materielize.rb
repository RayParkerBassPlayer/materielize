require "materielize/version"

module Materielize
  class ConfigSetup
    attr_reader :root_dir, :default_config_dir

    def initialize
      @root_dir = "materiel"
      @default_config_dir = "default_config_files"
    end

    def materiel_exists?
      Dir.exists?(root_dir)
    end

    def default_config_dir_exists?
      Dir.exists?(sub_path(default_config_dir))
    end

    # Basic setup of materiel.  Create materiel directory, default config subdirectory, throw around some READMEs, etc.
    def install
      Dir.mkdir(root_dir) if !materiel_exists?
      Dir.mkdir(sub_path(default_config_dir)) if !default_config_dir_exists?

      readme = File.open("#@root_dir/README.TXT", "w")
      readme << File.read(File.expand_path("lib/root.txt"))
      readme.flush
      readme.close
    end

    def init_cfg_files
      @project_root = Dir.getwd
      @root = File.expand_path(default_config_dir, root_dir)

      copy(@root) do |item|
        yield(item)
      end
    end

    private

    # Create path relative to 'materiel'
    def sub_path(name)
      File.expand_path(name, root_dir)
    end

    # ====================================================================================================================================================================
    # = Recursive call that winds through the materiel directory and copies default files.  Starting at materiel/default_config_files, the dir structure mimics the app  =
    # ====================================================================================================================================================================

    def copy(dir, &block)
      old_dir = Dir.getwd

      Dir.chdir(dir)
      cwd = Dir.getwd

      target_dir = @root + cwd.gsub(default_config_dir, "")

      for entry in Dir.entries(".") do
        next if entry == "." || entry == ".."

        if File.directory?(entry)
          if !Dir.exist?(entry)
            report_back(block, :message => "Creating directory #{entry}.")
            Dir.mkdir("#@project_root/#{entry}")
          end
          copy(entry, &block)
        else
          target_file = "#{target_dir}/#{entry}"

          if File.exists?(target_file)
            options = report_back(block, :message => "#{target_file} exists.  Overwrite? (y)es, (n)o, (a)ll or (c)ancel: ", :needs_confirmation => true, :confirmation => false)

            if options[:confirmation]
              report_back(block, :message => "Removing #{target_file}")
              FileUtils.rm(target_file)
            end
          end

          if !File.exists?(target_file)
            report_back(block, :message => "Creating #{entry}...")

            begin
              File.copy("#{cwd}/#{entry}", target_file)
            rescue => e
              report_back(block, :message => "Error copying file: #{e}")
            end
          else
            report_back(block, :message => "#{entry} exists, skipping...")
          end
        end
      end

      Dir.chdir(old_dir)
    end

    def report_back(block, options)
      block.call(options)
    end
  end
end
