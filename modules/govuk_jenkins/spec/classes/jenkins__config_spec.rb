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

    context 'true' do
      let (:params) { default_params.merge({
        :manage_config => true,
      })}

      it { is_expected.to contain_file('/var/lib/jenkins/config.xml').with_content(/<githubWebUri>wibble/) }
    end

    context 'authentication' do
      let (:params) { default_params.merge({
        :manage_permissions_github_teams => true,
        :user_permissions                => [{
          'user'        => 'admin_user',
          'permissions' => ['jenkins.perm.admin', 'jenkins.perm.edit'],
        }],
      })}

      it { is_expected.to contain_file('/var/lib/jenkins/config.xml').with_content(/<authorizationStrategy class="hudson.security.GlobalMatrixAuthorizationStrategy">/) }
      it { is_expected.to contain_file('/var/lib/jenkins/config.xml').with_content(/<permission>jenkins.perm.admin:admin_user<\/permission>\n\s+<permission>jenkins.perm.edit:admin_user<\/permission>/) }
    end
  end
end
