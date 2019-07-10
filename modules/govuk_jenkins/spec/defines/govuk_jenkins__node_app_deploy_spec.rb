require_relative '../../../../spec_helper'

describe 'govuk_jenkins::node_app_deploy', :type => :define do

  let(:title) { 'my_node_class' }

  let (:default_params) {{
    :project_dir    => '/path/to/dir',
    :apps           => [
      'super-furry-cat',
    ],
    :non_apps       => [
      'non-app-hairless-cat',
    ]
  }}

  context 'with default settings' do
    let(:params) { default_params }
    it { should contain_file('/path/to/dir/jobs/my_node_class').with_ensure('directory') }

    it { should contain_file('/path/to/dir/jobs/my_node_class/config.xml').with_content(/TARGET_APPLICATION=super-furry-cat/) }
    it { should contain_file('/path/to/dir/jobs/my_node_class/config.xml').with_content(/TARGET_APPLICATION=non-app-hairless-cat/) }
    it { should contain_file('/path/to/dir/jobs/my_node_class/config.xml').without_content(/authToken/) }
  end
  context 'with auth token' do
    let(:params) { default_params.merge({:auth_token => 'tim test token'}) }
    it { should contain_file('/path/to/dir/jobs/my_node_class/config.xml').with_content(/<authToken>tim test token<\/authToken>/) }
  end
end
