require 'gem_bundler'

describe "GemBundler" do
  before(:all) do
    GemBundler.instance.configure do |c|
      c.gem "gem1"
      c.gem "gem2", ">= 1.1.1"
    end
  end
  
  it "should install and package the gems" do
    FileUtils.rm_rf "spec/tmp" if File.exists? "spec/tmp"
    FileUtils.rm_rf "spec/lib" if File.exists? "spec/lib"
    
    FileUtils.mkdir_p "spec/lib"
    GemBundler.instance.setup("spec/tmp", "spec/lib")
    m = mock("DepInst")
    m.stub(:install)
    Gem::DependencyInstaller.should_receive(:new).and_return { FileUtils.cp_r "spec/skel", "spec/tmp"; m }
    GemBundler.instance.bundle
    File.exists?("spec/lib/1.jar").should be_true
    File.exists?("spec/lib/gems.jar").should be_true
    
    FileUtils.rm_rf "spec/tmp" if File.exists? "spec/tmp"
    FileUtils.rm_rf "spec/lib" if File.exists? "spec/lib"
  end
end
