require_relative '../../../../spec_helper'

describe 'puppet::puppetserver::sentry', :type => :class do
  let (:pre_condition) do
    <<-EOF
      class {'::puppet::puppetserver':
        sentry_dsn => 'rspec dsn',
      }
    EOF
  end

  Puppet.settings[:confdir] = '/etc/puppet'

  it do
    is_expected.to contain_exec('/usr/bin/puppetserver gem install sentry-raven')
    is_expected.to contain_file('/etc/puppet/sentry.conf').with_content('dsn=rspec dsn')
  end
end
