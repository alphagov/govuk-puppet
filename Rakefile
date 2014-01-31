require 'rspec/core/rake_task'
require 'puppet'

# FIXME: We shouldn't need to do this. puppet/face should. See:
# - http://projects.puppetlabs.com/issues/15529
# - https://groups.google.com/forum/#!topic/puppet-dev/Yk0WC1JZCg8/discussion
if (Puppet::PUPPETVERSION.to_i >= 3 && !Puppet.settings.app_defaults_initialized?)
  Puppet.initialize_settings
end

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
task :test => [:spec, :icinga_checks, :custom]

task :default => [:puppetfile, :syntax, :lint, :test]
