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
    setup = Materielize::ConfigSetup.new

    setup.init_cfg_files do |item|
      if item[:needs_confirmation]
        item[:confirmation] = ask(item[:message])
        puts
      else
        puts item[:message]
      end
    end

    puts "Done."
  end
end
