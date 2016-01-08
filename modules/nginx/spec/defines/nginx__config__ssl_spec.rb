require_relative '../../../../spec_helper'

describe 'nginx::config::ssl', :type => :define do
  let(:title) { 'foobar' }

  context 'certtype => www' do
    let(:params) {{ :certtype => 'www' }}

    it { is_expected.to contain_file('/etc/nginx/ssl/foobar.crt').with_ensure('present').with_content(/BEGIN CERTIFICATE/) }
    it { is_expected.to contain_file('/etc/nginx/ssl/foobar.key').with_ensure('present').with_content(/BEGIN RSA PRIVATE KEY/).with_mode('0640') }
  end

  context 'ensure => absent' do
    let(:params) {{ :certtype => 'www', :ensure => 'absent' }}

    it { is_expected.to contain_file('/etc/nginx/ssl/foobar.crt').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/nginx/ssl/foobar.key').with_ensure('absent') }
  end
end
