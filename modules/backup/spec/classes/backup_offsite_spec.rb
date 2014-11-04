require_relative '../../../../spec_helper'

describe 'backup::offsite', :type => :class do
  let(:default_params) {{
    :src_dirs      => ['/unused'],
    :gpg_key_id    => 'unused',
    :dest_host     => 'unused',
    :dest_host_key => 'unused',
  }}

  describe 'enable' do
    context 'false (default)' do
      let(:params) { default_params }

      it { should contain_duplicity('offsite-govuk-datastores').with(
        :ensure => 'absent',
      )}
    end

    context 'true' do
      let(:params) { default_params.merge({
        :enable        => true,
      })}

      it { should contain_duplicity('offsite-govuk-datastores').with(
        :ensure => 'present',
      )}
    end
  end

  describe 'dest_folder' do
    context 'relative path' do
      let(:params) { default_params.merge({
        :dest_folder   => 'some/path',
        :dest_host     => 'backup.example.com',
      })}

      it 'should include a single slash between host and path' do
        should contain_duplicity('offsite-govuk-datastores').with(
          :target => 'rsync://backup.example.com/some/path',
        )
      end
    end

    context 'absolute path' do
      let(:params) { default_params.merge({
        :dest_folder   => '/srv/some/path',
        :dest_host     => 'backup.example.com',
      })}

      it 'should include an "extra" slash between host and path' do
        should contain_duplicity('offsite-govuk-datastores').with(
          :target => 'rsync://backup.example.com//srv/some/path',
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
  end

  describe 'misc' do
    let(:params) { default_params }

    it 'should include service description in NRPE command' do
      should contain_duplicity('offsite-govuk-datastores').with(
        :post_command => /\\toffsite backup govuk datastores\\t/,
      )
    end

    it {
      # Leaky abstraction? We need to know that govuk::user creates the
      # parent directory for our file.
      should contain_file('/home/govuk-backup/.ssh').with_ensure('directory')
    }
  end
end
