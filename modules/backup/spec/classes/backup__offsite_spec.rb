require_relative '../../../../spec_helper'

describe 'backup::offsite', :type => :class do
  let(:default_params) {{
    :archive_directory => '/foo/bar',
    :dest_host         => 'unused',
    :dest_host_key     => 'unused',
    :jobs              => {
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
      :archive_directory => '/foo/bar',
      :sources           => ['/srv/strawberry', '/srv/apple'],
      :destination       => 'rsync://backup.example.com//srv/backup',
      :hour              => '1',
      :minute            => '0',
      :gpg_key_id        => '',
    )}
    it { is_expected.to contain_backup__offsite__job('caterpillar').with(
      :archive_directory => '/foo/bar',
      :sources           => '/srv/orange',
      :destination       => 'rsync://backup.example.com//srv/backup',
      :hour              => '2',
      :minute            => '30',
    )}
  end

  describe 'dest_host_key' do
    let(:params) { default_params.merge({
      :dest_host     => 'ice.cream',
      :dest_host_key => 'pickle',
    })}

    it {
      is_expected.to contain_sshkey('ice.cream').with_key('pickle')
    }

    it {
      # Leaky abstraction? We need to know that govuk_user creates the
      # parent directory for our file.
      is_expected.to contain_file('/home/govuk-backup/.ssh').with_ensure('directory')
    }
  end
end
