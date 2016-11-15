require_relative '../../../../spec_helper'

describe 'govuk_jenkins::config', :type => :class do
  describe 'manage config' do
    context 'false (default)' do
      let (:params) {{
        :manage_config => false,
      }}

      it { is_expected.not_to contain_file('/var/lib/jenkins/config.xml') }
    end

    context 'true' do
      let (:params) {{
        :manage_config => true,
      }}

      it { is_expected.to contain_file('/var/lib/jenkins/config.xml').with_content(/<githubWebUri>wibble/) }
    end
  end
end
