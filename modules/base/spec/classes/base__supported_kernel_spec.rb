require_relative '../../../../spec_helper'

describe 'base::supported_kernel', :type => :class do

  describe 'disabled on precise (default)' do
    let(:facts) {{ 'lsbdistcodename' => 'precise' }}
    it do
        should contain_package('update-manager-core')
        should_not contain_package('linux-generic-lts-trusty')
    end
  end

  describe 'enabled on precise' do
    let(:params) {{ 'enabled' => true }}
    let(:facts) {{ 'lsbdistcodename' => 'precise' }}
    it { should contain_package('linux-generic-lts-trusty') }
  end

  describe 'enabled on trusty' do
    let(:facts) {{ 'lsbdistcodename' => 'trusty' }}
    it { should_not contain_package('linux-generic-lts-trusty') }
  end

end
