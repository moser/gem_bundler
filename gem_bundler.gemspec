Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'gem_bundler'
  s.version = '0.1'
  s.summary = "Bundles gems into jars."
  s.files = Dir['LICENSE', 'Rakefile', 'Readme.rdoc', 'spec/**/*', 'lib/**/*'].select { |f| !(f =~ /~$/) }
  s.require_path = 'lib'
  s.executables = []
  s.has_rdoc = true
  s.author = "Martin Vielsmaier"
  s.email = "martin.vielsmaier@gmail.com"
  s.homepage = "http://moserei.de"
  s.requirements = ["Java's jar executable on path"]
end
