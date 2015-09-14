require_relative '../../../../spec_helper'

describe 'collectd::package', :type => :class do

  context 'precise' do
    let(:facts) {{ "lsbdistcodename" => "precise" }}

    it { is_expected.to contain_package('collectd-core').with_ensure('5.4.0-ppa1~precise1') }

    it { is_expected.to contain_package('libyajl1') }
  end

  context 'trusty' do
    let(:facts) {{ "lsbdistcodename" => "trusty" }}

    it { is_expected.to contain_package('collectd-core').with_ensure('5.4.0-3ubuntu2') }

    it { is_expected.to contain_package('libyajl2') }
  end

  context 'another release' do
    let(:facts) {{ "lsbdistcodename" => "utopic" }}

    it do
      is_expected.to raise_error(Puppet::Error, /Only precise and trusty are supported/)
    end
  end
end
