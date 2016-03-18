require_relative '../../../../spec_helper'

describe 'govuk_keepalived', :type => :class do
  let(:facts) {{
    :concat_basedir => '/tmp/concat',
  }}
  let(:params) {{
    'instances' => {},
  }}

  describe "if instances specified but no auth_pass set" do
    let(:params) {{
      'instances' => {'foo' => {}},
    }}

    it do
      is_expected.to raise_error(Puppet::Error, /^VRRP instances defined but auth_pass parameter not set/)
    end
  end

  describe "instances hash is empty and auth_pass not specified" do
    it do
      is_expected.to_not raise_error
    end
  end

  describe "auth_pass is set to an empty string" do
    let(:params) {{
      'auth_pass' => '',
      'instances' => {'foo' => {}},
    }}

    it do
      is_expected.to raise_error(Puppet::Error, /^VRRP instances defined but auth_pass parameter not set/)
    end
  end

  describe "auth_pass is too short" do
    let(:params) {{
      'auth_pass' => 'foo',
      'instances' => {},
    }}

    it do
      is_expected.to raise_error(Puppet::Error, /^validate_slength/)
    end
  end
end
