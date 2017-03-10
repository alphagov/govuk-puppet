require_relative '../../../../spec_helper'

describe 'cron::crondotdee' do

  let(:title) { 'true_cron' }

  let (:default_params) {{
    :command => '/bin/true',
    :hour    => '12',
    :minute  => '34',
  }}

  context 'with mandatory params' do
    let(:params) { default_params }

    it { should contain_file('/etc/cron.d/true_cron').with_content(/34 12 \* \* \* root \/bin\/true/) }
  end

  context 'with explicit empty string MAILTO' do
    let(:params) { default_params.merge({
      :mailto => '""',
    })}

    it { should contain_file('/etc/cron.d/true_cron').with_content(/MAILTO=""/) }
  end

  context 'with undefined MAILTO' do
    let(:params) { default_params.merge({
      :mailto => '',
    })}

    it { should contain_file('/etc/cron.d/true_cron').without_content(/MAILTO/) }
  end

  context 'with ensure set to absent' do
    let(:params) { default_params.merge({
      :ensure => 'absent',
    })}

    it { is_expected.to contain_file('/etc/cron.d/true_cron').with_ensure('absent') }
  end
end
