require_relative '../../../../spec_helper'

describe "collectd::plugin::etcd", :type => :class do
  let(:pre_condition) { 'Collectd::Plugin <||>' }
  let(:node) { 'test.example.com' }

  it 'Should create the correct resources' do
    is_expected.to contain_collectd__plugin('curl_json')
    # Test all the URLs interpolate correctly and that the looped keys are present
    is_expected.to contain_collectd__plugin('etcd').with_content(/<URL "http:\/\/test.example.com:2380\/v2\/admin\/config">\n[ ]*Instance "etcd_config"/)
    is_expected.to contain_collectd__plugin('etcd').with_content(/<Key "activeSize">\n[ ]*Type "gauge"\n[ ]*<\/Key>/)
    is_expected.to contain_collectd__plugin('etcd').with_content(/<URL "http:\/\/test.example.com:2379\/v2\/stats\/store">\n[ ]*Instance "etcd_store"/)
    is_expected.to contain_collectd__plugin('etcd').with_content(/<Key "compareAndSwapFail">\n[ ]*Type "counter"\n[ ]*<\/Key>/)
    is_expected.to contain_collectd__plugin('etcd').with_content(/<URL "test.example.com:2379\/v2\/stats\/self">\n[ ]*Instance "etcd_self"/)
    is_expected.to contain_collectd__plugin('etcd').with_content(/<Key "recvAppendRequestCnt">\n[ ]*Type "counter"\n[ ]*<\/Key>/)
  end
end
