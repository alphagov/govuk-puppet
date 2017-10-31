require_relative '../../../../spec_helper'

describe 'govuk_elasticsearch::backup', :type => :class do
  context 'Using AWS access keys should add the keys in the config' do
    let(:params){{
        :es_indices => [
            'cagney',
            'lacey'
        ],
        :aws_secret_access_key => 'foo',
        :aws_access_key_id => 'bar',
        :s3_bucket => 'mybucket',
    }}

    it { is_expected.to contain_file('/usr/local/bin/es-backup-s3').with_ensure('present').with_content(/"cagney","lacey"/).with_content(/"access_key": "bar",\n    "secret_key": "foo"/) }
    it { is_expected.to contain_cron__crondotdee('es-backup-s3').with_hour('0').with_minute('0') }
    it { is_expected.to contain_file('/usr/local/bin/es-restore-s3').with_ensure('present') }
    it { is_expected.to contain_file('/usr/local/bin/es-prune-snapshots').with_ensure('present') }
  end

  context 'If either of the AWS access keys are undefined it should not add any into config' do
    let(:params){{
        :es_indices => [
            'cagney',
            'lacey'
        ],
        :s3_bucket => 'mybucket',
        :aws_secret_access_key => 'foo',
    }}

    it { is_expected.to contain_file('/usr/local/bin/es-backup-s3').with_ensure('present').with_content(/"cagney","lacey"/).without_content(/"access_key": "bar",\n    "secret_key": "foo"/) }
  end

  context 'Not setting an S3 bucket' do
    let(:params){{
        :es_indices => [
            'cagney',
            'lacey'
        ],
    }}

    it { is_expected.to raise_error }
  end
end
