require_relative '../../../../spec_helper'

describe 'govuk_sudo' do

  context 'under Ubuntu with no class parameters' do

    let :facts do
    {
      :osfamily => 'debian',
      :operatingsystem => 'Ubuntu',
    }
    end

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('govuk_sudo') }
    it { is_expected.to contain_class('sudo') }
    it { is_expected.to contain_package('sudo') }

    it { is_expected.to contain_file('/etc/sudoers').with({
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
