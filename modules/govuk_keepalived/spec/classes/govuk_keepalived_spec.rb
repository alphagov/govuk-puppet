require_relative '../../../../spec_helper'

describe 'govuk_keepalived', :type => :class do
  let(:facts) {{
    :concat_basedir => '/tmp/concat',
  }}

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
