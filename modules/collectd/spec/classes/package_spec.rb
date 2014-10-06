require_relative '../../../../spec_helper'

describe 'collectd::package', :type => :class do

  context 'precise' do
    let(:facts) {{ "lsbdistcodename" => "precise" }}

    it { should contain_package('collectd-core').with_ensure('5.4.0-ppa1~precise1') }

    it { should contain_package('libyajl1') }
  end

  context 'trusty' do
    let(:facts) {{ "lsbdistcodename" => "trusty" }}

    it { should contain_package('collectd-core').with_ensure('5.4.0-3ubuntu2') }

    it { should contain_package('libyajl2') }
  end

  context 'another release' do
    let(:facts) {{ "lsbdistcodename" => "utopic" }}

    it do
      expect {
        should
      }.to raise_error(Puppet::Error, /Only precise and trusty are supported/)
    end
  end
end
