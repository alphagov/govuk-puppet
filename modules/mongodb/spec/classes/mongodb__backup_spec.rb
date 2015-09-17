require_relative '../../../../spec_helper'

describe 'mongodb::backup', :type => :class do
  let(:params) {{
    :enabled            => true,
    :replicaset_members => [ 'foo', 'bar', 'baz' ],
  }}

  describe 'whether enabled or not' do
    context 'on a machine not defined as a member of the replicaset' do
      let(:facts) {{
        :hostname => 'geronimo',
      }}

      it {
          is_expected.to raise_error(Puppet::Error, /This machine's hostname was not found in the list of MongoDB replicaset members/)
      }
    end

    context 'on a machine defined as a member of the replicaset' do
      let(:facts) {{
        :hostname => 'foo',
      }}

      it {
          is_expected.to_not raise_error
      }
    end
  end

  describe 'when enabled' do
    context 'on the first member of the replicaset it creates backups' do
      let(:facts) {{
        :hostname => 'foo',
      }}

      it {
        is_expected.to contain_file('/etc/cron.daily/automongodbbackup-replicaset').with_ensure('present')
      }
    end

    context 'on other members of the replicaset it does not create backups' do
      let(:facts) {{
        :hostname => 'bar',
      }}

      it {
        is_expected.to contain_file('/etc/cron.daily/automongodbbackup-replicaset').with_ensure('absent')
      }
    end
  end

  describe 'when disabled' do
    let(:params) {{
      :enabled            => false,
      :replicaset_members => [ 'foo', 'bar', 'baz' ],
    }}

    context 'on the first member of the replicaset it does not create backups' do
      let(:facts) {{
        :hostname => 'foo',
      }}

      it {
        is_expected.to contain_file('/etc/cron.daily/automongodbbackup-replicaset').with_ensure('absent')
      }
    end
  end
end
