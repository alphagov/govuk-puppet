require_relative '../../../../spec_helper'

describe 'nginx::config::vhost::redirect', :type => :define do
  let(:title) { 'gruffalo.example.com' }

  context 'to => https://mouse.example.com/' do
    let(:params) {{
      :to => 'https://mouse.example.com/',
    }}

    it { is_expected.to contain_nginx__config__site('gruffalo.example.com').with(
      :content => /^\s+server_name gruffalo\.example\.com;$/
    )}
    it { is_expected.to contain_nginx__config__site('gruffalo.example.com').with(
      :content => /^\s+rewrite \^\/\(\.\*\)\ https:\/\/mouse\.example\.com\/\$1 permanent;$/
    )}
    it { is_expected.to contain_nginx__config__ssl('gruffalo.example.com').with(
      :certtype => 'wildcard_publishing'
    )}
  end
end
