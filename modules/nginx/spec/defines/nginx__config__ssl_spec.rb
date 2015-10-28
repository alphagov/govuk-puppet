require_relative '../../../../spec_helper'

describe 'nginx::config::ssl', :type => :define do
  let(:title) { 'foobar' }

  context 'certtype => www' do
    let(:params) {{ :certtype => 'www' }}

    it { is_expected.to contain_file('/etc/nginx/ssl/foobar.crt').with_ensure('present').with_content('WWW_CRT') }
    it { is_expected.to contain_file('/etc/nginx/ssl/foobar.key').with_ensure('present').with_content('WWW_KEY').with_mode('0640') }
  end

  context 'ensure => absent' do
    let(:params) {{ :certtype => 'www', :ensure => 'absent' }}

    it { is_expected.to contain_file('/etc/nginx/ssl/foobar.crt').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/nginx/ssl/foobar.key').with_ensure('absent') }
  end
end
