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

  after(:all) do
    # just like a good neighbor...
    remove_materiel_dir
  end

  context "installation" do
    it "creates basic directories if they don't exist" do
      @setup.install

      @setup.materiel_exists?.should be true
      @setup.default_config_dir_exists?.should be true
      File.exist?(File.expand_path("README.txt", @setup.root_dir)).should be true
    end

    it "handles installation if directories do exist" do
      create_def_cfg_files_dir
      @setup.install

      @setup.materiel_exists?.should be true
      @setup.default_config_dir_exists?.should be true
      File.exist?(File.expand_path("README.txt", @setup.root_dir)).should be true
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

  context "copying default tree" do
    before(:each) do
      @paths_to_nuke = []
      @files_to_nuke = []
      @setup.install
    end

    after(:each) do
      for path in @paths_to_nuke do
        FileUtils.rm_rf(path)
      end

      for file in @files_to_nuke
        FileUtils.rm(file)
      end
    end

    context "creating reflection of default config directory" do
      it "handles creating directories that don't exist" do
        dir_name = "sub1"
        @paths_to_nuke << dir_name

        create_subdirectory(dir_name)

        @setup.init_cfg_files do |item|
          puts item[:message]

          if item[:needs_confirmation]
            item[:confirmation] = true
          end
        end

        Dir.exist?(dir_name).should be true
      end

      it "handles creating directories that don't exist, including many nested subdirectories" do
        sub1 = "sub1"
        sub2 = "sub1/sub2"
        sub3 = "sub1/sub2/sub3"
        @paths_to_nuke << sub1

        create_subdirectory(sub1)
        create_subdirectory(sub2)
        create_subdirectory(sub3)

        @setup.init_cfg_files do |item|
          puts item[:message]

          if item[:needs_confirmation]
            item[:confirmation] = true
          end
        end

        Dir.exist?(sub1).should be true
        Dir.exist?(sub2).should be true
        Dir.exist?(sub3).should be true
      end

      it "handles creating directories that do exist" do
        sub1 = "sub1"
        sub2 = "sub1/sub2"
        sub3 = "sub1/sub2/sub3"
        @paths_to_nuke << sub1

        Dir.mkdir(sub1)
        Dir.mkdir(sub2)
        Dir.mkdir(sub3)

        @setup.init_cfg_files do |item|
          puts item[:message]

          if item[:needs_confirmation]
            item[:confirmation] = true
          end
        end

        Dir.exist?(sub1).should be true
        Dir.exist?(sub2).should be true
        Dir.exist?(sub3).should be true
      end

      it "copies files that don't exist already" do
        sub_dir = "config"
        @paths_to_nuke << sub_dir

        # A file to be copied around.
        src_file_name = "spec/fixtures/empty_file.txt"

        # A config file in a subdirectory
        file1_path = "materiel/default_config_files/#{sub_dir}/config_file.txt"

        # A config file in the root directory
        file2_path = "materiel/default_config_files/config_file.txt"
        @files_to_nuke << "config_file.txt"


        create_subdirectory(sub_dir)

        FileUtils.cp(src_file_name, file1_path)
        FileUtils.cp(src_file_name, file2_path)

        @setup.init_cfg_files do |item|
          item[:needs_confirmation].should be false
        end

        File.exist?(file1_path).should be true
        File.exist?(file2_path).should be true
      end

      it "doesn't overwrite existing files by default" do
        sub1 = "config"
        @paths_to_nuke << sub1

        # The file that will try to be copied around from materiel
        src_file_name = "spec/fixtures/file_with_content.txt"

        # The file that will already be there.
        existing_file_name = "spec/fixtures/empty_file.txt"

        # Creating file path of default_cfg_file here for organization
        file1_path = "materiel/default_config_files/#{sub1}/config_file.txt"

        # Place spoof file in its 'production' location to be found by process
        FileUtils.cp(existing_file_name, "./root.txt")
        @files_to_nuke << "root.txt"


        # Creating file path of default_cfg_file here for organization
        Dir.mkdir("config")
        @paths_to_nuke << "config"
        file2_path = "materiel/default_config_files/root.txt"

        # Place spoof file in its 'production' location to be found by process
        FileUtils.cp(existing_file_name, "config/root.txt")

        create_subdirectory(sub1)

        # Now copy over files that are different than what exist.  This will make it easier to make sure that the files
        # were not overwritten.
        FileUtils.cp(src_file_name, file1_path)
        FileUtils.cp(src_file_name, file2_path)

        @setup.init_cfg_files do |item|
          if item[:needs_confirmation]
            # Deny the process's request to write over the file.
            item[:confirmation] = false
          end
        end

        FileUtils.identical?(existing_file_name, "root.txt").should be true
        FileUtils.identical?(existing_file_name, "config/root.txt").should be true
        FileUtils.identical?(src_file_name, "root.txt").should be false
        FileUtils.identical?(src_file_name, "config/root.txt").should be false
      end

      it "overwrites existing files if the user indicates yes" do
        pending "Write me."
      end

      it "does not overwrite existing files if the user indicates no" do
        pending "Write me."
      end

      it "overwrites all existing files if the user indicates all" do
        pending "Write me."
      end
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
