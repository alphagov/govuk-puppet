require_relative '../../../../spec_helper'

describe 'puppet::master', :type => :class do
  # concat_basedir needed for puppetdb module (for postgresql)
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat/'}}
  let (:hiera_data) {{
    :app_domain => 'giraffe.example.com',
  }}

  it do
    should contain_file('/etc/init/puppetmaster.conf').
      with_content(/unicornherder -u unicorn -p \$PIDFILE -- -p 9090 -c \/etc\/puppet\/unicorn.conf/)
    should contain_service('puppetmaster').with_provider('upstart').with_ensure('running')
  end

  it { should contain_class('puppetdb') }
  it { should contain_class('puppet::master::nginx') }

  it do
    should contain_class('puppet')
    should contain_class('puppet::master::config')
    should contain_file('/etc/puppet/config.ru')
  end
end
