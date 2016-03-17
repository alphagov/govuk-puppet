require_relative '../../../../spec_helper'

describe 'govuk_postgresql::wal_e::backup', :type => :class do
  let(:default_params) {{
    :aws_access_key_id     => 'tom-jones',
    :aws_secret_access_key => 'its-not-unusual',
    :s3_bucket_url         => 's3://foo/bar',
    :aws_region            => 'eu-west-1',
  }}

  context 'WAL-E backups enabled' do
    let(:params) { default_params.merge({
      :enabled                => true,
    })}

    it { is_expected.to contain_file('/etc/wal-e/').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/wal-e/env.d').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/wal-e/env.d/AWS_SECRET_ACCESS_KEY').with_content(/its-not-unusual/) }
    it { is_expected.to contain_file('/etc/wal-e/env.d/AWS_ACCESS_KEY_ID').with_content(/tom-jones/) }
    it { is_expected.to contain_file('/etc/wal-e/env.d/WALE_S3_PREFIX').with_content(/s3:\/\/foo\/bar/) }
    it { is_expected.to contain_file('/etc/wal-e/env.d/AWS_REGION').with_content(/eu-west-1/) }
  end

  context 'WAL-E backups enabled and GPG key is defined' do
    let(:params) { default_params.merge({
      :enabled                          => true,
      :wale_private_gpg_key             => 'i-key-therefore-i-am',
      :wale_private_gpg_key_fingerprint => 'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMN',
    })}

    it { is_expected.to contain_file('/etc/wal-e/env.d/WALE_GPG_KEY_ID').with_content(/ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMN/) }
    it { is_expected.to contain_file('/var/lib/postgresql/.gnupg').with_ensure('directory') }
    it { is_expected.to contain_file('/var/lib/postgresql/.gnupg/gpg.conf').with_content(/trust-model\ always/) }
    it { is_expected.to contain_file('/var/lib/postgresql/.gnupg/ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMN_secret_key.asc').with_content('i-key-therefore-i-am') }
    it { is_expected.to contain_exec('import_gpg_secret_key')
         .with_refreshonly(true)
    }
  end
end
