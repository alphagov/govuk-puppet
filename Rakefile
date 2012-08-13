require 'puppet'
require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'
require 'parallel_tests'
require 'parallel_tests/cli'

PuppetLint.configuration.send("disable_autoloader_layout")
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.send("disable_only_variable_string")
PuppetLint.configuration.send("disable_inherits_across_namespaces")

desc "Run rspec-puppet tests for modules"
RSpec::Core::RakeTask.new(:sspecmod) do |t|
  t.pattern = 'modules/*/spec/*/*_spec.rb'
  t.rspec_opts = "--color --format documentation"
end

desc "Run rspec-puppet tests for manifests"
RSpec::Core::RakeTask.new(:sspecman) do |t|
  t.pattern = 'manifests/spec/*_spec.rb'
  t.rspec_opts = "--color --format documentation"
end

desc "Run rspec-puppet tests for manifests and modules"
task :sspec => [:sspecman, :sspecmod]

desc "Run parallel_rspec tests for modules"
task :pspecmod do
  myargs = ["-t","rspec" ]
  myargs.concat(Dir['modules/*/spec/*/*_spec.rb'])
  ParallelTest::CLI.run(myargs)
end

desc "Run parallel_rspec for tests manifests"
task :pspecman do
  myargs = ["-t","rspec"]
  myargs.concat(Dir['manifests/spec/*_spec.rb'])
  ParallelTest::CLI.run(myargs)
end

desc "Run parallel_rspec tests for manifests and modules"
task :pspec do
  myargs = ["-t","rspec"]
  myargs.concat(Dir['manifests/spec/*_spec.rb'])
  myargs.concat(Dir['modules/*/spec/*/*_spec.rb'])
  ParallelTest::CLI.run(myargs)
end

# Set defaults to be parallel rspec
desc "Test manifests and modules"
task :spec => :pspec
desc "Test manifests only"
task :specman => :pspecman
desc "Test modules only"
task :specmod => :pspecmod

desc "Run rspec-puppet tests for manifests and modules and puppet-lint"
task :default => [:lint, :spec]
