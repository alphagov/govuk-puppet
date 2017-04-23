require_relative '../../../../spec_helper'

describe 'govuk_jenkins::jenkins_plugins', :type => :class do

  let(:params) {{
      :plugins_hash => {
          'nodelabelparameter'            => '1.7.2',
          'pipeline-multibranch-defaults' => '1.1',
          'powershell'                    => '1.3',
          'scalable-amazon-ecs'           => 'latest',
      }
  }}

  context 'Checking that array of plugins is correctly formatted' do

    it { is_expected.to contain_file('/var/lib/jenkins/plugins_list').with_content(/nodelabelparameter@1.7.2\spipeline-multibranch-defaults@1.1\spowershell@1.3\sscalable-amazon-ecs@latest/)}
  end

end
