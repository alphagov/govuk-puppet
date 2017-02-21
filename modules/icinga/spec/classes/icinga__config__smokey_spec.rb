require_relative '../../../../spec_helper'

describe 'icinga::config::smokey', :type => :class do
  let(:file_path) { '/etc/smokey.sh' }

  context 'with only http_username and http_password from hiera' do
    let (:params) {{
      'http_username' => 'test_username',
      'http_password' => 'test_password' 
    }}
    it { is_expected.to contain_file('/etc/smokey.sh').with_content(<<EOS
#!/bin/bash
export AUTH_PASSWORD="test_password"
export AUTH_USERNAME="test_username"
EOS
    )}
  end

  context 'with all variables set in hiera' do
    let(:params) {{
      'http_username' => 'test_username',
      'http_password' => 'test_password',
      'smokey_signon_email' => 'crocodile',
      'smokey_signon_password' => 'monkey',
      'smokey_bearer_token' => 'tortoise',
    }}
    # FIXME: Hack to refresh hieradata.
    let(:facts) {{ :cache_bust => Time.now }}

    it { is_expected.to contain_file('/etc/smokey.sh').with_content(<<EOS
#!/bin/bash
export AUTH_PASSWORD="test_password"
export AUTH_USERNAME="test_username"
export BEARER_TOKEN="tortoise"
export SIGNON_EMAIL="crocodile"
export SIGNON_PASSWORD="monkey"
EOS
    )}
  end
end
