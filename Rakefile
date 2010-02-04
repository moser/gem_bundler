require 'rake'
require 'spec/rake/spectask'

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts = ["--colour", "--format progress", "--loadby mtime"]
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.libs = [File.dirname(__FILE__) + '/lib']
end
