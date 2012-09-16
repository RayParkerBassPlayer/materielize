#noinspection RubyResolve
require "materielize"
require "highline/import"

class Materiel < Thor
  desc "install", "Set up the materielize directory if it doesn't already exist"
  def install
    setup = Materielize::ConfigSetup.new

    setup.install do |item|
      puts item[:message]
    end

    puts "Done."
  end

  desc "uninstall", "Remove the materiel directory"
  def uninstall
    setup = Materielize::ConfigSetup.new

    setup.uninstall do |item|
      puts item[:message]
    end

    puts "Done."
  end

  desc "init_config_files", "Copy default config files into place."
  def init_config_files
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
