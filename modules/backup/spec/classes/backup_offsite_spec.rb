require_relative '../../../../spec_helper'

describe 'backup::offsite', :type => :class do
  let(:default_params) {{
    :datastores_srcdirs => ['/unused'],
    :graphite_srcdir    => '/unused',
    :gpg_key_id         => 'unused',
    :datastores_destdir => 'unused',
    :graphite_destdir   => 'unused',
    :dest_host          => 'unused',
    :dest_host_key      => 'unused',
  }}

  describe 'enable' do
    context 'false (default)' do
      let(:params) { default_params }

      it { should contain_backup__offsite__job('govuk-datastores').with(
        :ensure => 'absent',
      )}
      it { should contain_backup__offsite__job('govuk-graphite').with(
        :ensure => 'absent',
      )}
    end

    context 'true' do
      let(:params) { default_params.merge({
        :enable        => true,
      })}

      it { should contain_backup__offsite__job('govuk-datastores').with(
        :ensure => 'present',
      )}
      it { should contain_backup__offsite__job('govuk-graphite').with(
        :ensure => 'present',
      )}
    end
  end

  describe 'datastores_destdir graphite_destdir' do
    context 'relative path' do
      let(:params) { default_params.merge({
        :datastores_destdir => 'some/path',
        :graphite_destdir   => 'some/path',
        :dest_host          => 'backup.example.com',
      })}

      it 'should include a single slash between host and path' do
        should contain_backup__offsite__job('govuk-datastores').with(
          :destination => 'rsync://backup.example.com/some/path',
        )
        should contain_backup__offsite__job('govuk-graphite').with(
          :destination => 'rsync://backup.example.com/some/path',
        )
      end
    end

    context 'absolute path' do
      let(:params) { default_params.merge({
        :datastores_destdir => '/srv/some/path',
        :graphite_destdir   => '/srv/some/path',
        :dest_host          => 'backup.example.com',
      })}

      it 'should include an "extra" slash between host and path' do
        should contain_backup__offsite__job('govuk-datastores').with(
          :destination => 'rsync://backup.example.com//srv/some/path',
        )
        should contain_backup__offsite__job('govuk-graphite').with(
          :destination => 'rsync://backup.example.com//srv/some/path',
        )
      end
    end
  end

  describe 'dest_host_key' do
    let(:params) { default_params.merge({
      :dest_host     => 'ice.cream',
      :dest_host_key => 'pickle',
    })}

    it {
      should contain_sshkey('ice.cream').with_key('pickle')
    }

    it {
      # Leaky abstraction? We need to know that govuk::user creates the
      # parent directory for our file.
      should contain_file('/home/govuk-backup/.ssh').with_ensure('directory')
    }
  end
end
