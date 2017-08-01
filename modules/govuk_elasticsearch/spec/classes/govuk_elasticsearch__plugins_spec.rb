require_relative '../../../../spec_helper'

describe 'govuk_elasticsearch::plugins', :type => :class do

  context 'Elasticsearch version 1.4.4 should install cloud-aws plugin 2.4.2' do
    let(:params) {{
      :elasticsearch_version => '1.4.4',
    }}
    it { is_expected.to contain_elasticsearch__plugin('elasticsearch/elasticsearch-cloud-aws/2.4.2') }
  end


  context 'Elasticsearch version 1.5.2 should install cloud-aws plugin 2.5.1' do
    let(:params) {{
      :elasticsearch_version => '1.5.2',
    }}
    it { is_expected.to contain_elasticsearch__plugin('elasticsearch/elasticsearch-cloud-aws/2.5.1') }
  end

  context 'Elasticsearch version 1.7.5 should install cloud-aws plugin 2.7.1' do
    let(:params) {{
      :elasticsearch_version => '1.7.5',
    }}
    it { is_expected.to contain_elasticsearch__plugin('elasticsearch/elasticsearch-cloud-aws/2.7.1') }
  end

  context 'Elasticsearch version 2.4.6 should install cloud-aws plugin' do
    let(:params) {{
      :elasticsearch_version => '2.4',
    }}
    it { is_expected.to contain_elasticsearch__plugin('cloud-aws') }
  end

  context 'Elasticsearch version 5.x.x should install the discovery-ec2 and repository-s3 plugins' do
    let(:params) {{
      :elasticsearch_version => '5.1.0',
    }}
    it { is_expected.to contain_elasticsearch__plugin('discovery-ec2') }
    it { is_expected.to contain_elasticsearch__plugin('repository-s3') }
  end

end
