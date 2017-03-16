require_relative '../../../../spec_helper'

describe 'backup::assets', :type => :class do
  let(:default_params) {{
    :archive_directory  => '/srv/.cache',
    :jobs               => {
      'hungry' => {
        'sources'     => ['/srv/strawberry', '/srv/apple'],
        'destination' => 'rsync://backup.example.com//srv/backup',
        'hour'        => 1,
        'minute'      => 0,
        'gpg_key_id'  => '',
      },
      'caterpillar' => {
        'sources'     => '/srv/orange',
        'destination' => 'rsync://backup.example.com//srv/backup',
        'hour'        => 2,
        'minute'      => 30,
      },
    },
  }}

  describe 'jobs' do
    let(:params) { default_params }

    it { is_expected.to contain_backup__offsite__job('hungry').with(
      :sources           => ['/srv/strawberry', '/srv/apple'],
      :destination       => 'rsync://backup.example.com//srv/backup',
      :hour              => '1',
      :minute            => '0',
      :gpg_key_id        => '',
      :archive_directory => '/srv/.cache',
    )}
    it { is_expected.to contain_backup__offsite__job('caterpillar').with(
      :sources           => '/srv/orange',
      :destination       => 'rsync://backup.example.com//srv/backup',
      :hour              => '2',
      :minute            => '30',
      :archive_directory => '/srv/.cache',
    )}
  end

end
