require 'csv'
require 'rspec-puppet'
require 'puppet'
require 'puppet/parser/functions/extlookup'

HERE = File.expand_path(File.dirname(__FILE__))

module MockExtdata
  def update_extdata(h)
    # FIXME: Currently update_extdata on each call overrides puppet extlookup
    # function, which is inefficient. This should be removed once we move to
    # hiera
    Puppet::Parser::Functions.newfunction(:extlookup, :type => :rvalue) do |args|
      extdata = {
        'app_domain'    => 'test.gov.uk',
        'website_root'  => 'www.test.gov.uk',
        'http_username' => 'test_username',
        'http_password' => 'test_password',
        'internal_tld'  => 'test',

        'google_client_id_datainsight'               => 'example client id',
        'google_client_secret_datainsight'           => 'example client secret',
        'google_analytics_refresh_token_datainsight' => 'example refresh token',
        'google_drive_refresh_token_datainsight'     => 'example refresh token'
      }.merge!(h)

      key, default = args
      extdata[key] || default or raise Puppet::ParseError, "No match found for '#{key}' in any data file during extlookup()"
    end
  end
end

RSpec.configure do |c|
  c.manifest    = File.join(HERE, 'manifests', 'site.pp')
  c.module_path = [
    File.join(HERE, 'modules'),
    File.join(HERE, 'vendor', 'modules')
  ].join(':')
  c.include MockExtdata

  c.before do
    # FIXME: We shouldn't need to do this. puppet/face should. See:
    # - http://projects.puppetlabs.com/issues/15529
    # - https://groups.google.com/forum/#!topic/puppet-dev/Yk0WC1JZCg8/discussion
    if (Puppet::PUPPETVERSION.to_i >= 3 && !Puppet.settings.app_defaults_initialized?)
      Puppet.initialize_settings
    end

    update_extdata({})
  end
end
