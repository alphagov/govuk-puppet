require_relative '../../../../spec_helper'

describe 'backup::assets', :type => :class do
  let(:default_params) {{
    :dest_host          => 'unused',
    :dest_host_key      => 'unused',
    :backup_private_key => '',
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

  describe 'dest_host_key' do
    let(:params) { default_params.merge({
      :dest_host     => 'ice.cream',
      :dest_host_key => 'pickle',
    })}

    it { is_expected.to contain_sshkey('ice.cream').with_key('pickle') }
  end

  describe 'backup_private_key' do
    let(:params) { default_params.merge({
      :backup_private_key => 'slice of cherry pie',
    })}

    it { is_expected.to contain_file('/root/.ssh/id_rsa').with({
      :mode => '0600',
      :content => 'slice of cherry pie',
    })}
  end
end
