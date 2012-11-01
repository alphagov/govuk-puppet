require 'rspec-puppet'

HERE = File.expand_path(File.dirname(__FILE__))

RSpec.configure do |c|
  c.module_path = File.join(HERE, 'modules')
  c.manifest    = File.join(HERE, 'manifests', 'site.pp')
end
