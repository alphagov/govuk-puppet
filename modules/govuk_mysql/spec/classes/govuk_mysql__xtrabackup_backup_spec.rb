require_relative '../../../../spec_helper'

describe 'govuk_mysql::xtrabackup::backup', :type => :class do
  let(:default_params) {{
    :aws_access_key_id     => 'lou-reed',
    :aws_secret_access_key => 'walk-on-the-wild-side',
    :s3_bucket_name        => 'foo',
    :aws_region            => 'eu-west-1',
    :encryption_key        => 'thisisnotarealkey'
  }}

  context 'MySQL S3 backups enabled' do
    let(:params) { default_params.merge({
      :enabled                => true,
    })}

    it { is_expected.to contain_file('/etc/mysql/xtrabackup').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/mysql/xtrabackup/env.d').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/mysql/xtrabackup/env.d/AWS_SECRET_ACCESS_KEY').with_content(/walk-on-the-wild-side/) }
    it { is_expected.to contain_file('/etc/mysql/xtrabackup/env.d/AWS_ACCESS_KEY_ID').with_content(/lou-reed/) }
    it { is_expected.to contain_file('/usr/local/bin/xtrabackup_s3_base').with_content(/.*innobackupex\ --extra-lsndir='\/var\/lib\/mysql\/'\ --encrypt=AES256\ --encrypt-key="thisisnotarealkey"\ --stream=xbstream\ --compress\ \.\ \|\ envdir \/etc\/mysql\/xtrabackup\/env\.d\ gof3r\ put\ --endpoint s3-eu-west-1\.amazonaws\.com\ -b\ foo\ -k\ \$\(cat \/var\/lib\/mysql\/xtrabackup_date\)\/base\.xbcrypt.*/) }
  end
end
