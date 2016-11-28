require_relative '../../../../spec_helper'

describe 'govuk_jenkins::config', :type => :class do
  let(:default_params) {{
    :github_client_id     => 'bar',
    :github_client_secret => 'baz',
  }}

  describe 'manage config' do
    context 'false (default)' do
      let (:params) { default_params.merge({
        :manage_config => false,
      })}

      it { is_expected.not_to contain_file('/var/lib/jenkins/config.xml') }
    end

    context 'true running jenkins version 2.19.2' do
      let (:params) { default_params.merge({
        :manage_config => true,
        :version       => '2.19.2',
      })}

      it { is_expected.to contain_file('/var/lib/jenkins/config.xml').with_content(/<githubWebUri>wibble/) }
      it { is_expected.to contain_file('/var/lib/jenkins/config.xml').with_content(/2.19.2/) }
      it { is_expected.to contain_file('/var/lib/jenkins/config.xml').with_content(/<crumbIssuer\sclass="hudson.security.csrf.DefaultCrumbIssuer">/) }
    end

    # We do not want to apply the CSRF protection on our existing jenkins environment
    context 'true running jenkins version 1.554.2' do
      let (:params) { default_params.merge({
       :manage_config => true,
       :version       => '1.554.2',
       })}

      it { is_expected.to contain_file('/var/lib/jenkins/config.xml').with_content(/<githubWebUri>wibble/) }
      it { is_expected.to contain_file('/var/lib/jenkins/config.xml').with_content(/1.554.2/) }
      it { is_expected.to contain_file('/var/lib/jenkins/config.xml').without_content(/<crumbIssuer\sclass="hudson.security.csrf.DefaultCrumbIssuer">/) }
    end
  end
end
