require_relative '../../../../spec_helper'

describe 'govuk_containers::app::config', :type => :class do
  context "default paramaters" do
    let(:params) do
      {
        :global_envvars => [ 'MICHAEL=JACKSON', 'JOHNNY=CASH' ],
        :global_env_file => '/the/file/goes/here',
      }
      it do
        is_expected.to contain_file('/the/file/goes/here').with_content(/# Managed by Puppet\nMICHAEL=JACKSON\nJOHNNY=CASH/)
      end
    end
  end
end
