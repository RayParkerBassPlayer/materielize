require "spec_helper"

describe Materielize::ConfigFiles do
  before(:each) do
    remove_dir
  end

  let(:materiel_dir){"materiel"}

  it "recognizes correctly if the materiel directory exists" do
    create_dir
    Materielize::ConfigFiles.materiel_exists?.should be true
  end

  it "recognizes correctly if the materiel directory does not exist" do
    Materielize::ConfigFiles.materiel_exists?.should be false
  end

  def create_dir
    if !Dir.exists?(materiel_dir)
      Dir.mkdir(materiel_dir)
    end
  end

  def remove_dir
    if Dir.exists?(materiel_dir)
      Dir.rmdir(materiel_dir)
    end
  end
end
