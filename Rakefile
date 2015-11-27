require 'rspec/core/rake_task'
require 'puppet'

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

desc "Run all tests except lint" # used by jenkins.sh
task :all_but_lint => [:puppetfile, :syntax, :bash_syntax, :yaml_syntax, :spec, :icinga_checks, :custom]

desc "Run all tests"
task :default => [:lint, :all_but_lint]
