#noinspection RubyResolve
require "spec_helper"

describe Materielize::ConfigSetup do
  before(:all) do
    @setup = Materielize::ConfigSetup.new

    @materiel_dir = "materiel"
    @default_config_files_dir = "default_config_files"
    @default_config_files_path = "#@materiel_dir/#@default_config_files_dir"
  end

  before(:each) do
    # Start each spec out in fresh territory
    remove_materiel_dir
  end

  context "installation" do
    it "creates basic directories if they don't exist" do
      @setup.install

      @setup.materiel_exists?.should be true
      @setup.default_config_dir_exists?.should be true
    end

    it "handles installation if directories do exist" do
      create_def_cfg_files_dir
      @setup.install

      @setup.materiel_exists?.should be true
      @setup.default_config_dir_exists?.should be true
    end
  end

  context "micro-ish helpers" do
    it "recognizes correctly if the materiel directory exists" do
      create_materiel_dir
      @setup.materiel_exists?.should be true
    end

    it "recognizes correctly if the materiel directory does not exist" do
      @setup.materiel_exists?.should be false
    end
    it "recognizes if the default config files directory doesn't exist" do
      @setup.default_config_dir_exists?.should be false
    end

    it "recognizes if the default config files directory does exist" do
      create_def_cfg_files_dir
      @setup.default_config_dir_exists?.should be true
    end
  end

  def create_subdirectory(subdirectory_name)
    subdir_path = "#@default_config_files_path/#{subdirectory_name}"
    create_def_cfg_files_dir

    if !Dir.exists?(subdir_path)
      Dir.mkdir(subdir_path)
    end
  end

  def create_def_cfg_files_dir
    create_materiel_dir

    if !Dir.exists?(@default_config_files_path)
      Dir.mkdir(@default_config_files_path)
    end
  end

  def create_materiel_dir
    if !Dir.exists?(@materiel_dir)
      Dir.mkdir(@materiel_dir)
    end
  end

  def remove_materiel_dir
    if Dir.exists?(@materiel_dir)
      FileUtils.rm_rf(@materiel_dir)
    end
  end
end
