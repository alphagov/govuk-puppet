require_relative '../../../../spec_helper'

describe 'govuk_elasticsearch::plugins', :type => :class do
  context 'Elasticsearch version 5.x.x should install the discovery-ec2 and repository-s3 plugins' do
    let(:params) {{
      :elasticsearch_version   => '5.1.0',
      :elasticsearch_configdir => '/etc/elasticsearch',
    }}
    it { is_expected.to contain_elasticsearch__plugin('discovery-ec2') }
    it { is_expected.to contain_elasticsearch__plugin('repository-s3') }
  end

end
