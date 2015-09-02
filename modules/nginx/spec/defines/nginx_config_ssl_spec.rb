require_relative '../../../../spec_helper'

describe 'nginx::config::ssl', :type => :define do
  let(:title) { 'foobar' }

  context 'certtype => www' do
    let(:params) {{ :certtype => 'www' }}
    let(:hiera_data) {{
        'www_crt' => 'WWW_CRT',
        'www_key' => 'WWW_KEY',
    }}

    it { should contain_file('/etc/nginx/ssl/foobar.crt').with_ensure('present').with_content('WWW_CRT') }
    it { should contain_file('/etc/nginx/ssl/foobar.key').with_ensure('present').with_content('WWW_KEY').with_mode('0640') }
  end

  context 'ensure => absent' do
    let(:params) {{ :certtype => 'www', :ensure => 'absent' }}

    let(:hiera_data) {{
        'www_crt' => 'WWW_CRT',
        'www_key' => 'WWW_KEY',
    }}

    it { should contain_file('/etc/nginx/ssl/foobar.crt').with_ensure('absent') }
    it { should contain_file('/etc/nginx/ssl/foobar.key').with_ensure('absent') }
  end
end
