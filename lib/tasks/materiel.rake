#noinspection RubyResolve
require "materielize"
require "highline/import"

namespace :materiel do
  desc "Set up the materielize directory if it doesn't already exist"
  task :install do
    setup = Materielize::ConfigSetup.new

    setup.install do |item|
      puts item[:message]
    end

    puts "Done."
  end

  desc "Remove the materiel directory"
  task :uninstall do
    setup = Materielize::ConfigSetup.new

    setup.uninstall do |item|
      puts item[:message]
    end

    puts "Done."
  end

  desc "Copy default config files into place."
  task :init_config_files do
    force = parse_args(ARGV)

    setup = Materielize::ConfigSetup.new

    setup.init_cfg_files(force_all: force) do |item|
      if item[:needs_confirmation]
        item[:confirmation] = ask(item[:message])
        puts
      else
        puts item[:message]
      end
    end

    puts "Done."
  end

  def parse_args(args)
    if args.count > 2
      puts "'force' is the only option"
      puts "EX: rake materiel:init_config_files force"
      raise ArgumentError
    end

    # No args given
    return false if args.count == 1

    # Swallow the arg so that it's not considered a real rake task by rake
    option = args[1]
    task option.to_sym do ; end

    # Return true if force given as an arg.
    return args[1].downcase == "force"
  end
end
