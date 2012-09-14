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

      copy([root_dir, default_config_dir]) do |item|
        yield(item)
      end
    end

    private

    # Create path relative to 'materiel'
    def sub_path(name)
      File.expand_path(name, root_dir)
    end

    def copy(path_parts, &block)
      current_path = File.expand_path(File.join(*path_parts))

      for entry in Dir.entries(File.expand_path(current_path, ".")) do
        next if entry == "." || entry == ".."

        # The original, be it a directory or a file
        src = File.expand_path(entry, current_path)

        # The thing that might need to be created, copied, etc.
        target = File.join(@project_root, *path_parts.reject{|part| [root_dir, default_config_dir].include?(part)}, entry)

        if File.directory?(src)
          # Figure path of an unknown depth of directories and subdirectories, slice off the materiel directory
          # and create the currently found directory under its matching sibling under the project root
          if !Dir.exist?(target)
            report_back(block, :message => "Creating directory '#{target}'.")
            Dir.mkdir(target)
          end

          # Inter-dimensional travel time...
          copy(path_parts + [entry], &block)
        else
          # It's a file
          if File.exist?(target)
            options = report_back(block, {message: "'#{target}' exists.  Overwrite? (y)es, (n)o, (a)ll or (c)ancel:", needs_confirmation: true})
            puts options.inspect
          else
            report_back(block, message: "Creating #{target}.")
            FileUtils.cp(src, target)
          end
        end
      end
    end

    def report_back(block, options)
      default_options = {needs_confirmation: false}.merge(options)
      block.call(default_options)
      default_options
    end
  end
end
