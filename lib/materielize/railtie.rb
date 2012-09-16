require 'materielize'
require 'rails'

module Materielize
  class Railtie < Rails::Railtie
    railtie_name :materielize

    rake_tasks do
      puts "CWD:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #{Dir.cwd}"
      load "/tasks/materiel.rake"
      #load "lib/tasks/materiel.thor"
    end
  end
end
