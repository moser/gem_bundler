require 'rubygems'
require 'fileutils'
require 'rubygems/dependency_installer'
require 'singleton'

# :include:../Readme.rdoc
class GemBundler
  include Singleton

  attr_accessor :install_dir, :jar_dir, :gems
  
  # Set the needed paths. 
  # - install_dir: The gems will be temporarily installed into this directory. Caution: Before installing the directory will be delete.
  # - jar_dir: The directory where the JAR files will be put.
  def setup(install_dir, jar_dir)
    @install_dir = install_dir
    @jar_dir = jar_dir
  end

  def configure
    yield self if block_given?
  end
  
  # Adds a gem
  #   gem "activerecord", ">= 2.3.1"
  def gem(name, version = "")
    @gems ||= {}
    @gems[name] = version
  end
  
  # Checks if all required gems are installed and returns
  # gems that miss.
  def check_gems
    @gems ||= {}
    @gems.keys.select { |g| Gem.source_index.find_name(g, @gems[g]).size == 0 }
  end
  
  # Bundles the required gems into a JAR file.
  # Before the gems are packed into the JAR, all JARs inside the gems are moved to the jar_dir.
  def bundle
    raise "Paths not given! Call setup first." if @install_dir.nil? || @jar_dir.nil?
    gems_jar = File.join(jar_dir, 'gems.jar')
    default_options = { :generate_rdoc => false, 
                        :generate_ri => false,
                        :install_dir => install_dir }
    FileUtils.rm_rf install_dir if File.exists? install_dir
    FileUtils.mkdir_p install_dir
    installer = Gem::DependencyInstaller.new(default_options)
    @gems.each do |name, version|
      puts "Installing #{name}"
      installer.install(name, version || Gem::Requirement.default)      
    end
    Dir.glob("#{install_dir}/**/*.jar").each do |jar|
      FileUtils.mv jar, File.join(jar_dir, jar.split("/").last)
    end
    FileUtils.rm gems_jar if File.exists? gems_jar
    `jar cf #{gems_jar} -C #{install_dir} .`
  end
end
