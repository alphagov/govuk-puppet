require 'csv'
require 'rspec-puppet'
require 'puppet'
require 'hiera-puppet-helper'
require 'puppet/parser/functions/extlookup'

# For testing functions.
require 'puppetlabs_spec_helper/module_spec_helper'

HERE = File.expand_path(File.dirname(__FILE__))

class Puppet::Resource
  # If you test a class which has a default parameter, but don't
  # explicitly pass the parameter in, puppet explodes because it tries
  # to automatically inject parameter values from hiera and gets
  # confused due to hiera-puppet-helper's antics. This monkey patch
  # disables automatic parameter injection to stop that happening.
  # TODO: perhaps push this upstream to hiera-puppet-helper?
  def lookup_external_default_for(param, scope)
    nil
  end
end

module MockExtdata
  def update_extdata(h)
    # FIXME: Currently update_extdata on each call overrides puppet extlookup
    # function, which is inefficient. This should be removed once we move to
    # hiera
    Puppet::Parser::Functions.newfunction(:extlookup, :type => :rvalue) do |args|
      extdata = {
        'http_username' => 'test_username',
        'http_password' => 'test_password',
        'internal_tld'  => 'test',
      }.merge!(h)

      key, default = args
      extdata[key] || default or raise Puppet::ParseError, "No match found for '#{key}' in any data file during extlookup()"
    end
  end
end

RSpec.configure do |c|
  c.mock_framework = :rspec

  c.manifest    = File.join(HERE, 'manifests', 'site.pp')
  c.module_path = [
    File.join(HERE, 'modules'),
    File.join(HERE, 'vendor', 'modules')
  ].join(':')
  c.include MockExtdata

  # Sensible defaults to satisfy modules that perform OS checking. These
  # keys can be overridden by more specific `let(:facts)` in spec contexts.
  c.default_facts = {
    :osfamily        => 'Debian',
    :operatingsystem => 'Ubuntu',
    :lsbdistcodename => 'Precise',
  }

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
