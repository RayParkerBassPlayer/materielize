require "spec_helper"

describe Materielize::ConfigFiles do
  before(:all) do
    @materiel_dir = "materiel"
    @default_config_files_dir = "default_config_files"
    @default_config_files_path = "#@materiel_dir/#@default_config_files_dir"
  end

  before(:each) do
    # Start each spec out in fresh territory
    remove_materiel_dir
  end

  it "recognizes correctly if the materiel directory exists" do
    create_materiel_dir
    Materielize::ConfigFiles.materiel_exists?.should be true
  end

  it "recognizes correctly if the materiel directory does not exist" do
    Materielize::ConfigFiles.materiel_exists?.should be false
  end

  context "default config files directory of materiel" do
    it "recognizes if the default config files directory doesn't exist" do
      Materielize::ConfigFiles.default_config_dir_exists?.should be false
    end

    it "recognizes if the default config files directory does exist" do
      create_def_cfg_files_dir
      Materielize::ConfigFiles.default_config_dir_exists?.should be true
    end

    it "creates mirrored subdirectory if it doesn't exist" do
      dir_name = "materieled_config_dir"
      create_subdirectory(dir_name)

      Materielize::ConfigFiles.materiel_exists?.should be true
    end

    it "doesn't have a problem if the subdirectory does exist" do
      pending "Write me"
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

    if !Dir.exists?(@default_config_files_dir)
      Dir.mkdir(@default_config_files_dir)
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
