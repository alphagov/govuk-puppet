require_relative '../../../../spec_helper'

describe "collectd::plugin::elasticsearch", :type => :class do
  let(:pre_condition) { 'Collectd::Plugin <||>' }
  let(:params){ {
    :es_port => 4242,
    :log_index_type_count => {
      'test_index' => ['type_1',]
    }
  } }

  it 'Includes the correct resources' do
    is_expected.to contain_class('Collectd::Plugin::Elasticsearch')
    is_expected.to contain_class('Collectd::Plugin::Curl_json')
    is_expected.to contain_collectd__Plugin('curl_json')
  end

  it 'Sets the URL correctly' do
    is_expected.to contain_collectd__plugin("elasticsearch").with_content(/<URL "http:\/\/127\.0\.0\.1:4242\/_nodes\/_local\/stats\/indices,http,jvm,process,transport">/)
  end

  it 'Sets the standard metrics' do
    is_expected.to contain_collectd__plugin("elasticsearch").with_content(/<Key "nodes\/\*\/indices\/docs\/count">\n[\s]*Type "gauge"\n[\s]*Instance "indices\.docs\.count"\n/)
  end

  it 'Sets index specific metrics' do
    is_expected.to contain_collectd__plugin("elasticsearch").with_content(/<URL "http:\/\/127\.0\.0\.1:4242\/test_index\/type_1\/_count">\n[\s]*Instance "elasticsearch"\n[\s]*<Key "count">\n[\s]*Type "gauge"\n[\s]*Instance "test_index_type_1_count"/)
  end
end
