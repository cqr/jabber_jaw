require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jabber_jaw"
    gem.summary = %Q{DSL for human message handling}
    gem.description = %Q{JabberJaw is a Sinatra-inspired DSL for building a message handler with humans on the other end.}
    gem.email = "carhoden@gmail.com"
    gem.homepage = "http://github.com/chrisrhoden/jabber_jaw"
    gem.authors = ["chrisrhoden"]
    gem.add_development_dependency "rspec", "1.2.9"
    gem.add_dependency "xmpp4r", "0.5"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

gem 'rspec', '1.2.9'
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "jabber_jaw #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
