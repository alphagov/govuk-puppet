require_relative '../../../../spec_helper'

describe 'collectd::plugin::raindrops', :type => :define do
  let(:pre_condition) { 'Collectd::Plugin <||>' }

  describe 'when passing a valid title and port' do
    let(:title) { 'otter' }
    let(:params) {{ :port => '3009' }}

    it {
        should contain_collectd__plugin('raindrops-otter').with_content(<<EOS
<Plugin curl>
  <Page "raindrops-otter">
    URL "http://localhost:3009/_raindrops"
    <Match>
      Regex "^calling: ([0-9]+)$"
      DSType "GaugeLast"
      Type "current_connections"
      Instance "calling"
    </Match>
    <Match>
      Regex "^writing: ([0-9]+)$"
      DSType "GaugeLast"
      Type "current_connections"
      Instance "writing"
    </Match>
    <Match>
      Regex ":3009 active: ([0-9]+)$"
      DSType "GaugeLast"
      Type "current_connections"
      Instance "active"
    </Match>
    <Match>
      Regex ":3009 queued: ([0-9]+)$"
      DSType "GaugeLast"
      Type "current_connections"
      Instance "queued"
    </Match>
  </Page>
</Plugin>
EOS
    )}
  end


  describe 'when title is invalid' do
    let(:title) { 'this makes for a bad filename' }
    let(:params) {{ :port => 3009 }}

    it do
      expect {
        should contain_collectd__plugin('raindrops-otter')
      }.to raise_error(Puppet::Error, /validate_re/)
    end
  end
end
