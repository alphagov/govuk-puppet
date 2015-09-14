require_relative '../../../../spec_helper'

describe 'base::supported_kernel', :type => :class do

  describe 'disabled on precise (default)' do
    let(:facts) {{ 'lsbdistcodename' => 'precise' }}
    it do
        is_expected.to contain_package('update-manager-core')
        is_expected.not_to contain_package('linux-generic-lts-trusty')
    end
  end

  describe 'enabled on precise' do
    let(:params) {{ 'enabled' => true }}
    let(:facts) {{ 'lsbdistcodename' => 'precise' }}
    it { is_expected.to contain_package('linux-generic-lts-trusty') }
  end

  describe 'enabled on trusty' do
    let(:facts) {{ 'lsbdistcodename' => 'trusty' }}
    it { is_expected.not_to contain_package('linux-generic-lts-trusty') }
  end

end
