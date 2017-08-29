require_relative '../../../../spec_helper'

describe 'puppet::puppetserver::package', :type => :class do
  let(:params) {{
    :puppetdb_version => '2.3.4',
  }}

  it { is_expected.to contain_package('puppetserver') }
  it { is_expected.to contain_package('puppetdb-terminus').with_ensure('2.3.4') }
end

