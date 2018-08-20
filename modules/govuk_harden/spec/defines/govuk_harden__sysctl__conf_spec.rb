require_relative '../../../../spec_helper'

describe 'govuk_harden::sysctl::conf', :type => :define do
  let(:title) { 'zebra' }
  let(:pre_condition) { 'File <| tag == "govuk_harden::sysctl::conf" |>' }

  context 'source param' do
    let(:params) {{ :source => 'puppet:///llama' }}
    it { is_expected.to contain_file('/etc/sysctl.d/70-zebra.conf').with(
      :source  => 'puppet:///llama',
      :content => nil,
    )}
  end

  context 'content param' do
    let(:params) {{ :content => 'llama' }}
    it { is_expected.to contain_file('/etc/sysctl.d/70-zebra.conf').with(
      :source  => nil,
      :content => 'llama',
    )}
  end

  context 'prefix => 10' do
    let(:params) {{ :prefix => '10', :content => 'llama' }}
    it { is_expected.to contain_file('/etc/sysctl.d/10-zebra.conf') }
  end
end
