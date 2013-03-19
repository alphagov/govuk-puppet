require 'rspec/core/rake_task'

def get_modules
  if ENV['mods']
    ENV['mods'].split(',').map { |x| x == 'manifests' ? x : "modules/#{x}" }
  else
    ['manifests', 'modules/*']
  end
end

FileList['lib/tasks/*.rake'].each do |rake_file|
  import rake_file
end

desc "Run all tests"
task :test => [:spec, :nagios_checks, :custom]

desc "Check for all Puppet syntax errors"
task :syntax => [:syntax_erb, :syntax_pp]

task :default => [:syntax_pp, :syntax_erb, :lint, :test]
