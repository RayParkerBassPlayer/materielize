#noinspection RubyResolve
require "materielize"

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
end
