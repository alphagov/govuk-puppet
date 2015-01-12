require_relative '../../../../spec_helper'

describe 'govuk_heka::nginx' do
  context 'fqdn_underscore fact present' do
    let(:facts) {{
      :fqdn_underscore => 'test_example_com',
    }}

    it { should contain_heka__plugin('nginx').with_content(/^hostname = "test_example_com"$/) }
  end

  context 'fqdn_underscore fact absent' do
    let(:facts) {{
      :fqdn_underscore => nil,
    }}

    it { expect { should }.to raise_error(Puppet::Error, /^Unable to load `fqdn_underscore` fact/) }
  end
end
