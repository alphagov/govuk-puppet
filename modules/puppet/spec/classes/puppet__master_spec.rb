require_relative '../../../../spec_helper'

describe 'puppet::master', :type => :class do
  # concat_basedir needed for puppetdb module (for postgresql)
  let(:facts) {{
    :concat_basedir => '/var/lib/puppet/concat/',
    :id             => 'root',
    :path           => 'concatted_file',
  }}

  it do
    is_expected.to contain_file('/etc/init/puppetmaster.conf').
      with_content(/unicornherder -u unicorn -p \$PIDFILE -- -p 9090 -c \/etc\/puppet\/unicorn.conf/)
    is_expected.to contain_service('puppetmaster').with_provider('upstart').with_ensure('running')
  end

  it { is_expected.to contain_class('govuk_puppetdb') }
  it { is_expected.to contain_class('puppet::master::nginx') }

  it do
    is_expected.to contain_class('puppet')
    is_expected.to contain_class('puppet::master::config')
    is_expected.to contain_file('/etc/puppet/config.ru')
  end
end
