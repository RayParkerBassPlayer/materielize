# Materielize

This is to assist in the always-messy proposition of configuration files and the like that need to be part of your Rails app, but you don't want production credentials and such being posted in your repo.  Also, as settings are added to project for new features (i.e., configuration settings in YAML files), team members will want to get the updated default settings for their development environment.

Materielize is born out of the way that I prefer to deal with this.  I invariably have a 'materiel' directory that contains various things that are needed in the project, but not necessarily part of the code base.  Also, I have a directory tree that mirrors the project itself with all of the default configuration files.  When setting up the project fresh, materielize gives you rake tasks to create the basic structure (install) and then copy config files over to your project from the default (init_config_files).

## Installation

Add this line to your application's Gemfile:

    gem 'materielize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install materielize

## Usage

    $ rake materiel:install

Creates the materiel directory and the default_config_files subdirectory.  The default config_files_directory root is a mirror-image of your project directory.  File in this directory will be copied to the root directory of your project, sub directories are sub directories of your project and so on.

    $ rake materiel:init_config_files
This copies files to their mirrored locations.  If files are already present you will be prompted if you want to overwrite them.

    $ rake materiel:uninstall
This will remove the materiel directory, recursively.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
