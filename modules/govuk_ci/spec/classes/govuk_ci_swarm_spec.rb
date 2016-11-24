require_relative '../../../../spec_helper'

describe 'govuk_ci::agent::swarm', :type => :class do

  let(:params) {{
      :agent_labels => [
          'earth',
          'mars',
          'saturn',
      ]
  }}

  context 'The jenkins upstart configuration file' do
    it { is_expected.to contain_file('jenkins-agent.conf').with_path('/etc/init/jenkins-agent.conf').with_content(/'earth\smars\ssaturn'/) }
  end
end
