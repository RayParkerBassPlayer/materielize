# Materielize

This is to assist in the always-messy proposition of configuration files and the like that need to be part of your project, but you don't want production credentials and such being posted in your repo.  Also, as settings are added to project for new features (i.e., configuration settings in YAML files), team members will want to get the updated default settings for their development environment.

Materielize is born out of the way that I prefer to deal with this.  I invariably have a 'materiel' directory that contains various things that are needed in the project, but not necessarily part of the code base.  Also, I have a directory tree the mirrors the project itself with all of the default configuration files.  When setting up the project fresh, materielize gives you Thor tasks to create the basic structure (install) and then copy config files over to your project from the default (init_config_files).

## Installation

Add this line to your application's Gemfile:

    gem 'materielize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install materielize

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
