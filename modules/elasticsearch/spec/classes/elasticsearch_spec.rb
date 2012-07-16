require_relative '../../../../spec_helper'

describe 'elasticsearch', :type => :class do
  let(:params) { { 'cluster' => 'carlisNotAwesome' } }
  it { should contain_package('elasticsearch') }
  it { should contain_file('/etc/elasticsearch/elasticsearch.yml')\
			   .with_content(/^\s*cluster.name: govuk-carlisNotAwesome$/) }
  it { should contain_file('/etc/default/elasticsearch') }
end
