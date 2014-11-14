require_relative '../../../../spec_helper'

describe 'backup::assets', :type => :class do
  let(:default_params) {{
    :dest_host          => 'unused',
    :dest_host_key      => 'unused',
    :backup_private_key => '',
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
        'hour'        => 1,
        'hour'        => 2,
        'minute'      => 30,
      },
    },
  }}

  describe 'jobs' do
    let(:params) { default_params }

    it { should contain_backup__offsite__job('hungry').with(
      :sources     => ['/srv/strawberry', '/srv/apple'],
      :destination => 'rsync://backup.example.com//srv/backup',
      :hour        => '1',
      :minute      => '0',
      :gpg_key_id  => '',
    )}
    it { should contain_backup__offsite__job('caterpillar').with(
      :sources     => '/srv/orange',
      :destination => 'rsync://backup.example.com//srv/backup',
      :hour        => '2',
      :minute      => '30',
    )}
  end

  describe 'archive_directory' do
    context 'unspecified (default)' do
      let(:params) { default_params }

      it { should contain_backup__offsite__job('hungry').with(
        :archive_directory => 'unset',
      )}
      it { should contain_backup__offsite__job('caterpillar').with(
        :archive_directory => 'unset',
      )}
    end

    context 'true' do
      let(:params) { default_params.merge({
        :archive_directory => '/srv/.cache',
      })}

      it { should contain_backup__offsite__job('hungry').with(
        :archive_directory => '/srv/.cache',
      )}
      it { should contain_backup__offsite__job('caterpillar').with(
        :archive_directory => '/srv/.cache',
      )}
    end
  end

  describe 'dest_host_key' do
    let(:params) { default_params.merge({
      :dest_host     => 'ice.cream',
      :dest_host_key => 'pickle',
    })}

    it { should contain_sshkey('ice.cream').with_key('pickle') }
  end

  describe 'backup_private_key' do
    let(:params) { default_params.merge({
      :backup_private_key => 'slice of cherry pie',
    })}

    it { should contain_file('/root/.ssh/id_rsa').with({
      :mode => '0600',
      :content => 'slice of cherry pie',
    })}
  end
end
