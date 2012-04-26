require 'puppet'
require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.send("disable_autoloader_layout")
PuppetLint.configuration.send("disable_80chars")

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'modules/*/spec/*/*_spec.rb'
  t.rspec_opts = "--color --format documentation"
end

task :default => [:spec, :lint]
