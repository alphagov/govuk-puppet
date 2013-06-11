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

task :default => [:puppetfile, :syntax, :lint, :test]
