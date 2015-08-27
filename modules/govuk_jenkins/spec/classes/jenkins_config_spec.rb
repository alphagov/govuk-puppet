require_relative '../../../../spec_helper'

describe 'govuk_jenkins::config', :type => :class do
  describe 'manage config' do
    let(:hiera_data) {{
      'govuk_jenkins::config::github_api_uri' => 'foo',
      'govuk_jenkins::config::github_client_id' => 'bar',
      'govuk_jenkins::config::github_client_secret' => 'baz',
      'govuk_jenkins::config::github_web_uri' => 'bobble',
    }}

    context 'false (default)' do
      let (:params) {{
        :manage_config => false,
      }}

      it { should_not contain_file('/var/lib/jenkins/config.xml') }
    end

    context 'true' do
      let (:params) {{
        :manage_config => true,
      }}

      it { should contain_file('/var/lib/jenkins/config.xml') }
    end
  end
end
