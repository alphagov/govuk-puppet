require_relative '../../../../spec_helper'

describe 'nginx::config::ssl', :type => :define do
  let(:title) { 'foobar' }

  context 'certtype => www' do
    let(:params) {{ :certtype => 'www' }}
    before {
      update_extdata({
        'www_crt' => 'WWW_CRT',
        'www_key' => 'WWW_KEY',
      })
    }

    it { should contain_file('/etc/nginx/ssl/foobar.crt').with_content('WWW_CRT') }
    it { should contain_file('/etc/nginx/ssl/foobar.key').with_content('WWW_KEY') }
  end

  context 'certtype => wildcard_alphagov_mgmt' do
    let(:params) {{ :certtype => 'wildcard_alphagov_mgmt' }}

    context 'values present in extdata' do
      before { update_extdata({
          'wildcard_alphagov_crt'       => 'WILDCARD_CRT',
          'wildcard_alphagov_key'       => 'WILDCARD_KEY',
          'wildcard_alphagov_mgmt_crt'  => 'MGMT_CRT',
          'wildcard_alphagov_mgmt_key'  => 'MGMT_KEY',
      })}
      let(:facts) {{ :cache_bust => Time.now }}

      it { should contain_file('/etc/nginx/ssl/foobar.crt').with_content('MGMT_CRT') }
      it { should contain_file('/etc/nginx/ssl/foobar.key').with_content('MGMT_KEY') }
    end

    context 'values absent fallback to wildcard_alphagov' do
      before { update_extdata({
          'wildcard_alphagov_crt' => 'FALLBACK_CRT',
          'wildcard_alphagov_key' => 'FALLBACK_KEY',
      })}
      let(:facts) {{ :cache_bust => Time.now }}

      it { should contain_file('/etc/nginx/ssl/foobar.crt').with_content('FALLBACK_CRT') }
      it { should contain_file('/etc/nginx/ssl/foobar.key').with_content('FALLBACK_KEY') }
    end
  end
end
