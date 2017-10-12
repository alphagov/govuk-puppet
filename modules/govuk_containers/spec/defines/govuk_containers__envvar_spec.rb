require_relative '../../../../spec_helper'

describe 'govuk_containers::envvar', :type => :define do
  let(:title) { 'bella' }

  context 'default options' do
    let(:params) {{
        :directory => '/path/to/dir',
        :envvars => {
          'furry'   => 'socks',
          'smuggle' => 'plops',
          'smelly'  => 'bums',
        }
      }}
    it { is_expected.to contain_file('/path/to/dir/bella.env').with_content(
      /# File managed by Puppet\nFURRY=socks\nSMUGGLE=plops\nSMELLY=bums\n$/
    )}
  end
end
