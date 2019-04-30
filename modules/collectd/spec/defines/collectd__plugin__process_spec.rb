require_relative '../../../../spec_helper'

describe 'collectd::plugin::process', :type => :define do
  let(:pre_condition) { 'Collectd::Plugin <||>' }

  describe 'when title is valid' do
    let(:title) { 'giraffe' }

    it {
        is_expected.to contain_collectd__plugin('process-giraffe').with_content(<<EOS
<Plugin Processes>
  CollectFileDescriptor true
  Process "giraffe"
</Plugin>
EOS
      )}

    describe 'regex is provided' do
      let(:params) {{
        :regex => '^gi.*fe$',
      }}

      it {
        is_expected.to contain_collectd__plugin('process-giraffe').with_content(<<EOS
<Plugin Processes>
  CollectFileDescriptor true
  ProcessMatch "giraffe" "^gi.*fe$"
</Plugin>
EOS
      )}
    end

    describe "disables CollectFileDescriptor on precise" do
      let(:facts) {{ 'lsbdistcodename' => 'precise' }}
      let(:title) { 'giraffe' }

      it {
        is_expected.to contain_collectd__plugin('process-giraffe').with_content(<<EOS
<Plugin Processes>
  Process "giraffe"
</Plugin>
EOS
      )}
    end

    describe 'regex containing single and double blackslash' do
      let(:params) {{
        :regex => "^giraffe\\\.giraffe\\\\$",
      }}

      it {
        is_expected.to contain_collectd__plugin('process-giraffe').with_content(<<EOS
<Plugin Processes>
  CollectFileDescriptor true
  ProcessMatch "giraffe" "^giraffe\\\\.giraffe\\\\\\\\$"
</Plugin>
EOS
      )}
    end
  end

  describe 'when title is invalid' do
    let(:title) { 'this makes for a bad filename' }

    it do
      expect {
        is_expected.to contain_collectd__plugin('process-giraffe')
      }.to raise_error(Puppet::Error, /validate_re/)
    end
  end
end
