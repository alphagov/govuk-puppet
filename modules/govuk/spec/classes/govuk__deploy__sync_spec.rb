require_relative '../../../../spec_helper'

describe 'govuk::deploy::sync', :type => :class do
  let(:params) { {jenkins_domain: 'jenkins', auth_token: 'token'} }
  let(:facts) { {aws_migration: 'node'} }
  it { is_expected.to contain_file('/usr/local/bin/govuk_sync_apps').with_content(/#{Regexp.escape('curl')}/) }
end
