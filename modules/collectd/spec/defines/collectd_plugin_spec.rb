require_relative '../../../../spec_helper'

describe 'collectd::plugin', :type => :define do
  let(:title) { 'giraffe' }
  let(:pre_condition) { 'File <| tag == "collectd::plugin" |>' }

  context 'source param' do
    let(:params) {{ :source => 'puppet:///donkey' }}
    it { should contain_file('/etc/collectd/conf.d/giraffe.conf').with(
      :source  => 'puppet:///donkey',
      :content => nil,
    )}
  end

  context 'content param' do
    let(:params) {{ :content => 'donkey' }}
    it { should contain_file('/etc/collectd/conf.d/giraffe.conf').with(
      :source  => nil,
      :content => 'donkey',
    )}
  end

  context 'no params' do
    let(:params) {{}}
    it { should contain_file('/etc/collectd/conf.d/giraffe.conf').with(
      :source  => nil,
      :content => "LoadPlugin giraffe\n",
    )}
  end

  context 'prefix => 00-' do
    let(:params) {{ :prefix => '00-' }}
    it { should contain_file('/etc/collectd/conf.d/00-giraffe.conf') }
  end
end
