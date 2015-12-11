require_relative '../../../../spec_helper'

describe 'mongodb::configure_replica_set', :type => :class do
  describe 'configure-replica-set' do
    describe 'sets replica set name' do
      let(:params) {{
        'members'         => {
          '123.456.789.123' => {},
          '987.654.321.012' => {},
          '432.434.454.454:457' => {},
        },
        'replicaset_name' => 'production',
      }}

      it {
        is_expected.to contain_file('/etc/mongodb/configure-replica-set.js').with_content(
          /_id: "production"/)
      }
    end
  end

  describe 'configure-node-priority' do
    context 'should run after the replica set is bootstrapped' do
      let(:params) {{
        'members' => {
          '1.2.3.4' => {},
          '5.6.7.8' => {},
        },
        'replicaset_name' => 'production',
      }}

      it {
        is_expected.to contain_exec('configure-node-priority')
          .that_requires('Exec[configure-replica-set]')
      }
    end

    context 'priority' do
      context 'should default to 1 when no params are set' do
        let(:params) {{
          'members' => {
            '1.2.3.4' => {},
            '5.6.7.8' => {},
          },
          'replicaset_name' => 'production',
        }}

        it { is_expected.to contain_file('/etc/mongodb/configure-node-priority.js').with_content(
          /\{\s+host: '1.2.3.4:27017',\s+priority: 1,\n/)
        }
      end

      context 'should default to 1 when the priority param is not set' do
        let(:params) {{
          'members' => {
            '1.2.3.4' => {'another_param' => 'some_value'},
            '5.6.7.8' => {},
          },
          'replicaset_name' => 'production',
        }}

        it { is_expected.to contain_file('/etc/mongodb/configure-node-priority.js').with_content(
          /\{\s+host: '1.2.3.4:27017',\s+priority: 1,\n/)
        }
      end

      context 'should use the priority param when it is set' do
        let(:params) {{
          'members' => {
            '1.2.3.4' => {'priority' => 0.5},
            '5.6.7.8' => {},
          },
          'replicaset_name' => 'production',
        }}

        it { is_expected.to contain_file('/etc/mongodb/configure-node-priority.js').with_content(
          /\{\s+host: '1.2.3.4:27017',\s+priority: 0.5,\n/)
        }
      end
    end

    context 'hidden nodes' do
      context 'should default not hidden when no params are set' do
        let(:params) {{
          'members' => {
            '1.2.3.4' => {},
            '5.6.7.8' => {},
          },
          'replicaset_name' => 'production',
        }}

        it { is_expected.to contain_file('/etc/mongodb/configure-node-priority.js').with_content(
          /\{\s+host: '1.2.3.4:27017',\s+[a-z: \d]+,\s+hidden: false,\n/)
        }
      end

      context 'should default to not hidden when the hidden param is not set' do
        let(:params) {{
          'members' => {
            '1.2.3.4' => {'another_param' => 'some_value'},
            '5.6.7.8' => {},
          },
          'replicaset_name' => 'production',
        }}

        it { is_expected.to contain_file('/etc/mongodb/configure-node-priority.js').with_content(
          /\{\s+host: '1.2.3.4:27017',\s+[a-z: \d]+,\s+hidden: false,\n/)
        }
      end

      context 'should use the hidden param when it is set' do
        let(:params) {{
          'members' => {
            '1.2.3.4' => {'hidden' => true},
            '5.6.7.8' => {},
          },
          'replicaset_name' => 'production',
        }}

        it { is_expected.to contain_file('/etc/mongodb/configure-node-priority.js').with_content(
          /\{\s+host: '1.2.3.4:27017',\s+[a-z: \d]+,\s+hidden: true,\n/)
        }
      end
    end
  end
end
