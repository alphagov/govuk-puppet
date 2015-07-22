require_relative '../../../../spec_helper'

describe 'govuk_jenkins::config', :type => :class do

  describe 'manage config' do
    let(:hiera_data) {{
      'govuk_jenkins::config::github_client_id' => %w{ foo },
      'govuk_jenkins::config::github_client_secret' => %w{ bar },
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

      it { should contain_file('/var/lib/jenkins/config.xml')
          .with_content(/foo/)
          .with_content(/bar/)
      }
    end
  end
end
