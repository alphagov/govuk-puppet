require 'csv'
require 'rspec-puppet'
require 'puppet'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'hiera-puppet-helper'

HERE = File.expand_path(File.dirname(__FILE__))

module GovukHieraDefaults
  extend RSpec::SharedContext
  HIERA_DEFAULT_DATA = {
    'app_domain'   => 'environment.example.com',
    'asset_root'   => 'http://assets.example.com',
    'website_root' => 'http://www.example.com',
    'internal_tld' => 'example',

    'heka::plugin::tcp_output::host' => 'heka.example.com',
    'heka::plugin::tcp_output::port' => 123,
  }

  let(:hiera_config) {{
    :backends => ['rspec'],
    :rspec => respond_to?(:hiera_data) ? HIERA_DEFAULT_DATA.merge(hiera_data) : HIERA_DEFAULT_DATA
  }}
end

RSpec.configure do |c|
  c.mock_framework = :rspec
  c.include(GovukHieraDefaults)

  c.manifest    = File.join(HERE, 'manifests')
  c.module_path = [
    File.join(HERE, 'modules'),
    File.join(HERE, 'vendor', 'modules')
  ].join(':')

  c.order = 'rand'

  # Sensible defaults to satisfy modules that perform OS checking. These
  # keys can be overridden by more specific `let(:facts)` in spec contexts.
  c.default_facts = {
    :osfamily                => 'Debian',
    :operatingsystem         => 'Ubuntu',
    :operatingsystemrelease  => '12.04',
    :lsbdistid               => 'Debian',
    :lsbdistcodename         => 'Precise',
  }

end
