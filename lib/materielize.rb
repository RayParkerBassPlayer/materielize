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

        # new_dir can also be a file, but naming it optimistically
        new_dir = File.expand_path(entry, current_path)

        if File.directory?(new_dir)
          # Figure path of an unknown depth of directories and subdirectories, slice off the materiel directory
          # and create the currently found directory under its matching sibling under the project root
          to_create = File.join(@project_root, *path_parts.reject{|part| [root_dir, default_config_dir].include?(part)}, entry)
          if !Dir.exist?(to_create)
            report_back(block, :message => "Creating directory #{to_create}.")
            Dir.mkdir(to_create)
          end

          # Inter-dimensional travel time...
          copy(path_parts + [entry], &block)
        end
      end
    end

    def report_back(block, options)
      block.call(options)
    end
  end
end
