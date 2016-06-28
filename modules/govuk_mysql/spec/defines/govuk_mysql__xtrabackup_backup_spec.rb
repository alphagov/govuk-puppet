require_relative '../../../../spec_helper'

describe 'govuk_mysql::xtrabackup::backup', :type => :define do
  context 'title defined' do
    let(:title) { 'foo-server-1.bar' }
    context 'parameters defined' do
      let(:params) {{
        :aws_access_key_id     => 'lou-reed',
        :aws_secret_access_key => 'walk-on-the-wild-side',
        :s3_bucket_name        => 'foo',
        :aws_region            => 'eu-west-1',
        :encryption_key        => 'thisisnotarealkey'
      }}

      it { is_expected.to contain_file('/etc/mysql/xtrabackup').with_ensure('directory') }
      it { is_expected.to contain_file('/etc/mysql/xtrabackup/env.d').with_ensure('directory') }
      it { is_expected.to contain_file('/etc/mysql/xtrabackup/env.d/AWS_SECRET_ACCESS_KEY').with_content(/^walk-on-the-wild-side$/) }
      it { is_expected.to contain_file('/etc/mysql/xtrabackup/env.d/AWS_ACCESS_KEY_ID').with_content(/^lou-reed$/) }
      it { is_expected.to contain_file('/usr/local/bin/xtrabackup_s3_base').with_content(/thisisnotarealkey/) }
    end
  end
end
