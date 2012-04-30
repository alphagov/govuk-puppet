require 'puppet'
require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.send("disable_autoloader_layout")
PuppetLint.configuration.send("disable_80chars")

desc <<-EOD
Run rspec-puppet tests for modules
EOD
RSpec::Core::RakeTask.new(:specmod) do |t|
  t.pattern = 'modules/*/spec/*/*_spec.rb'
  t.rspec_opts = "--color --format documentation"
end

desc <<-EOD
Run rspec-puppet tests for manifests
EOD
RSpec::Core::RakeTask.new(:specman) do |t|
  t.pattern = 'manifests/spec/*_spec.rb'
  t.rspec_opts = "--color --format documentation"
end


desc <<-EOD
Run rspec-puppet tests for manifests and modules
EOD
task :spec => [:specman, :specmod]

desc <<-EOD
Run rspec-puppet tests for manifests and modules and run puppet-lint
EOD
task :default => [:spec, :lint]
