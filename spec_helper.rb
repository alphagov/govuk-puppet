require 'csv'
require 'rspec-puppet'
require 'puppet'
require 'puppet/parser/functions/extlookup'

HERE = File.expand_path(File.dirname(__FILE__))

RSpec.configure do |c|
  c.manifest    = File.join(HERE, 'manifests', 'site.pp')
  c.module_path = [
    File.join(HERE, 'modules'),
    File.join(HERE, 'vendor', 'modules')
  ].join(':')

  c.before do
    # FIXME: We shouldn't need to do this. puppet/face should. See:
    # - http://projects.puppetlabs.com/issues/15529
    # - https://groups.google.com/forum/#!topic/puppet-dev/Yk0WC1JZCg8/discussion
    if (Puppet::PUPPETVERSION.to_i >= 3 && !Puppet.settings.app_defaults_initialized?)
      Puppet.initialize_settings
    end

    # Mock out extdata for the purposes of testing.
    module Puppet::Parser::Functions
      newfunction(:extlookup, :type => :rvalue) do |args|
        key, default = args
        {
          'app_domain'    => 'test.gov.uk',
          'website_root'  => 'www.test.gov.uk',
          'http_username' => 'test_username',
          'http_password' => 'test_password',

          'google_client_id_datainsight'               => 'example client id',
          'google_client_secret_datainsight'           => 'example client secret',
          'google_analytics_refresh_token_datainsight' => 'example refresh token',
          'google_drive_refresh_token_datainsight'     => 'example refresh token'
        }[key] || default or raise Puppet::ParseError, "No match found for '#{key}' in any data file during extlookup()"
      end
    end
  end
end
