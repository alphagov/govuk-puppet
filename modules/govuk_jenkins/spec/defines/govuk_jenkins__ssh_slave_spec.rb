require_relative '../../../../spec_helper'

describe 'govuk_jenkins::ssh_slave', :type => :define do

  let(:title) { 'jenkins-agent-1' }

  let (:default_params) {{
    :agent_hostname => 'jenkins-agent.domain',
    :credentials_id => 'catsarethebest',
    :labels         => 'mongo docker postgres'
  }}

  context 'with default settings' do
    let(:params) { default_params }
    it { should contain_file('/var/lib/jenkins/nodes/jenkins-agent-1/config.xml').with_content(/<label>mongo docker postgres/) }
    it { should contain_file('/var/lib/jenkins/nodes/jenkins-agent-1/config.xml').with_content(/<name>jenkins-agent-1/) }
    it { should contain_file('/var/lib/jenkins/nodes/jenkins-agent-1/config.xml').with_content(/<credentialsId>catsarethebest/) }
  end
end
