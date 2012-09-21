require "materielize/version"
require "materielize/railtie" if defined?(Rails)

module Materielize
  class ConfigSetup
    attr_reader :root_dir, :default_config_dir

    def initialize
      @root_dir = "materiel"
      @default_config_dir = "default_config_files"
      @overwrite_all = false
    end

    def materiel_exists?
      Dir.exists?(root_dir)
    end

    def default_config_dir_exists?
      Dir.exists?(sub_path(default_config_dir))
    end

    # Basic setup of materiel.  Create materiel directory, default config subdirectory, throw around some READMEs, etc.
    def install
      root_path = File.expand_path(root_dir)
      if !materiel_exists?
        yield({message: "Creating directory '#{root_path}'."}) if block_given?
        Dir.mkdir(root_path)
      else
        yield({message: "Directory '#{root_path}' already exists, no need to create."}) if block_given?
      end

      default_config_path = File.expand_path(default_config_dir, root_dir)

      if !default_config_dir_exists?
        yield({message: "Creating directory '#{default_config_path}'."}) if block_given?
        Dir.mkdir(default_config_path)
      else
        yield({message: "Directory '#{default_config_path}' already exists, no need to create."}) if block_given?
      end
    end

    def uninstall
      root_path = File.expand_path(root_dir)
      yield({message: "Uninstalling: Removing #{root_path}"}) if block_given?
      FileUtils.rm_rf(root_path)
    end

    def init_cfg_files(options = {})
      @overwrite_all = {force_all: false}.merge(options)[:force_all] # initialize if not indicated so as to not inadvertently cause disaster on a second call or somesuch.
      @project_root = Dir.getwd
      @root = File.expand_path(default_config_dir, root_dir)

      begin
        copy([root_dir, default_config_dir]) do |item|
          yield(item)
        end
      rescue Interrupt => e
        yield {message: e.message, needs_confirmation: false}
      end
    end

    # Valid single-character responses from the user
    def accepted_user_responses
      %w[a A n N c C] + [true, false]
    end

    # Confirm that the user response is valid.  Accepts either a string (char) response or the
    # the whole response/messaging hash.  Booleans also accepted.
    def valid_user_response?(response)
      if response.is_a?(String) || response.is_a?(TrueClass)|| response.is_a?(FalseClass)
        accepted_user_responses.include?(response)
      elsif response.is_a?(Hash)
        accepted_user_responses.include?(response[:confirmation])
      end
    end

    private

    # Create path relative to 'materiel'
    def sub_path(name)
      File.expand_path(name, root_dir)
    end

    # This only handles a yes, no or all type of response.  If a (c)ancel response
    # is to be caught, do it before you check with this.
    def user_confirmed?(response_options)
      # overwrite all sticks
      return @overwrite_all if @overwrite_all

      # no response is a false response
      return false if response_options[:confirmation].nil?

      # make response lower case for simplicity
      response = response_options[:confirmation].downcase

      # Set overwrite all and return if indicated
      @overwrite_all = true if response == "a"
      return @overwrite_all if @overwrite_all


      return false if response == "n"
      true if response == "y"
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
            # Initialize, but value won't (shouldn't) be used
            options = {}

            # If a forced overwrite of all is indicated, this stuff gets in the way.
            if !@overwrite_all
              options = report_back(block, {message: "'#{target}' exists.  Overwrite? (y)es, (n)o, (a)ll or (c)ancel: ", needs_confirmation: true, confirmation: false})

              # Check for a user cancellation before anything is done.
              if %w[c C].include?(options[:confirmation])
                message = "User cancelled operation."
                report_back(block, message: message)
                raise Interrupt.new(message)
              end
            end

            # Replace the file if the user confirms or has chosen "all"
            if @overwrite_all || user_confirmed?(options)
              report_back(block, {message: "Replacing #{target} because a force/replace was indicated."})
              FileUtils.rm(target)
              FileUtils.cp(src, target)
            else
              report_back(block, {message: "Skipping #{target}"})
            end
          else
            # File doesn't exist, so jsut write it.
            report_back(block, message: "Creating #{target}.")
            FileUtils.cp(src, target)
          end
        end
      end
    end

    def report_back(block, options)
      default_options = {needs_confirmation: false, confirmation: false}.merge(options)
      block.call(default_options)
      default_options
    end
  end
end
