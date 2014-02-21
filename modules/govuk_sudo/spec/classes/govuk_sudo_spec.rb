require_relative '../../../../spec_helper'

describe 'govuk_sudo' do

  context 'under Ubuntu with no class parameters' do

    let :facts do
    {
      :osfamily => 'debian',
      :operatingsystem => 'Ubuntu',
    }
    end

    it { should compile.with_all_deps }

    it { should contain_class('govuk_sudo') }
    it { should contain_class('sudo') }
    it { should contain_package('sudo') }

    it { should contain_file('/etc/sudoers').with({
        'ensure' => 'present',
        'path'    => '/etc/sudoers',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0440',
        'source'  => 'puppet:///modules/govuk_sudo/sudoers'
      })
    }

  end

end
