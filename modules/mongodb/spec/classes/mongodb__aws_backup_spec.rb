require_relative '../../../../spec_helper'

describe 'mongodb::aws_backup', :type => :class do
  context "default settings" do
    let(:params){{ 'bucket' => 'my-bucket' }}
    it { is_expected.to contain_file('/var/lib/mongodb/backup').with_ensure('absent') }
    it { is_expected.to contain_file('/usr/local/bin/mongodump-to-s3').with_ensure('absent') }
    it { is_expected.to contain_cron__crondotdee('mongodump-to-s3') }
  end
end
