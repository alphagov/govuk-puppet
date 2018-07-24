require_relative '../../../../spec_helper'

describe 'puppet::puppetserver::sentry', :type => :class do
  let (:pre_condition) do
    <<-EOF
      class {'::puppet::puppetserver':
        sentry_dsn => 'rspec dsn',
      }
    EOF
  end

  it do
    is_expected.to contain_exec('/usr/bin/puppetserver gem install sentry-raven')
    is_expected.to contain_file_line('puppetserver_sentry_dsn').with_line('export SENTRY_DSN="rspec dsn"')
  end
end

