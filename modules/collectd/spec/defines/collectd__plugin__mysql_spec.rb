require_relative '../../../../spec_helper'

describe 'collectd::plugin::mysql', :type => :define do
  let(:pre_condition) { <<EOS
Collectd::Plugin <||>
Govuk_mysql::User <||>
EOS
  }
  let(:param_defaults) {{
    :collectd_mysql_password => 'password',
  }}
  let(:title) { 'lazy_eval_workaround' }

  context 'when master' do
    let(:params) { param_defaults.merge({
      :master => true,
    })}

    it { is_expected.to contain_collectd__plugin('mysql').with_content(/^\s+MasterStats true$/) }
    it { is_expected.not_to contain_collectd__plugin('mysql').with_content(/SlaveStats/) }
    it { is_expected.to contain_govuk_mysql__user('collectd@localhost') }
  end

  context 'when slave' do
    let(:params) { param_defaults.merge({
      :slave => true,
    })}

    it { is_expected.not_to contain_collectd__plugin('mysql').with_content(/MasterStats/) }
    it { is_expected.to contain_collectd__plugin('mysql').with_content(/^\s+SlaveStats true$/) }
    it { is_expected.not_to contain_govuk_mysql__user('collectd@localhost') }
  end

  context 'when standalone server' do
    let(:params) { param_defaults }

    it { is_expected.not_to contain_collectd__plugin('mysql').with_content(/MasterStats/) }
    it { is_expected.not_to contain_collectd__plugin('mysql').with_content(/SlaveStats/) }
    it { is_expected.to contain_govuk_mysql__user('collectd@localhost') }
  end

  context 'when master and slave' do
    let(:params) { param_defaults.merge({
      :master => true,
      :slave => true,
    })}

    it do
      expect {
        is_expected.to contain_collectd__plugin('mysql')
      }.to raise_error(Puppet::Error, /master and slave are mutually exclusive options/)
    end
  end
end
