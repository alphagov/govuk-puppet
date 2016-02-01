require_relative '../../../../spec_helper'

describe 'govuk_ghe_vpn', :type => :class do

  let(:params) {{
    'url'      => 'foo',
    'username' => 'bar',
    'password' => 'baz',
  }}

  it { is_expected.to compile }
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('govuk_ghe_vpn') }

end
