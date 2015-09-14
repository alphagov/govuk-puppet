require_relative '../../../../spec_helper'

describe 'collectd::plugin::mysql', :type => :define do
  let(:pre_condition) { <<EOS
Collectd::Plugin <||>
Govuk_mysql::User <||>
EOS
  }
  let(:title) { 'lazy_eval_workaround' }

  context 'when master' do
    let(:params) {{
      :master => true,
    }}

    it { is_expected.to contain_collectd__plugin('mysql').with_content(/^\s+MasterStats true$/) }
    it { is_expected.not_to contain_collectd__plugin('mysql').with_content(/SlaveStats/) }
    it { is_expected.to contain_govuk_mysql__user('collectd@localhost') }
  end

  context 'when slave' do
    let(:params) {{
      :slave => true,
    }}

    it { is_expected.not_to contain_collectd__plugin('mysql').with_content(/MasterStats/) }
    it { is_expected.to contain_collectd__plugin('mysql').with_content(/^\s+SlaveStats true$/) }
    it { is_expected.not_to contain_govuk_mysql__user('collectd@localhost') }
  end

  context 'when standalone server' do
    let(:params) {{ }}

    it { is_expected.not_to contain_collectd__plugin('mysql').with_content(/MasterStats/) }
    it { is_expected.not_to contain_collectd__plugin('mysql').with_content(/SlaveStats/) }
    it { is_expected.to contain_govuk_mysql__user('collectd@localhost') }
  end

  context 'when master and slave' do
    let(:params) {{
      :master => true,
      :slave => true,
    }}

    it do
      expect {
        is_expected.to contain_collectd__plugin('mysql')
      }.to raise_error(Puppet::Error, /master and slave are mutually exclusive options/)
    end
  end
end
