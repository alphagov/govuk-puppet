require_relative '../../../../spec_helper'

describe 'mongodb::server', :type => :class do
  let(:facts) {{
    'hostname' => 'mongo-box-1'
  }}

  describe "with the default package name" do
    let(:params) { {
      'version' => '2.4.6',
      'replicaset_members' => {'mongo-box-1' => {}},
     } }
    it do
      is_expected.to contain_package('mongodb-10gen').with_ensure('2.4.6')
      is_expected.to contain_file('/etc/mongodb.conf')
    end
  end

  describe "with package version > 3" do
    let(:params) { {
      'version' => '3.2.7',
      'replicaset_members' => {'mongo-box-1' => {}},
     } }
    it do
      is_expected.to contain_package('mongodb-org').with_ensure('3.2.7')
      is_expected.to contain_file('/etc/mongod.conf')
      is_expected.to contain_class('mongodb::service').with_service_name('mongod')
    end
  end

  describe "not setting the replica set members" do
    let(:params) { {
      'version' => '2.0.7',
    } }

    it do
      is_expected.to raise_error(Puppet::Error, /^Replica set can't have no members/)
    end
  end

  describe "replica set can have one member" do
    let(:params) { {
      'version' => '2.0.7',
      'replicaset_members' => {'mongo-box-1' => {}},
    } }

    it do
      is_expected.to contain_file('/etc/mongodb.conf').with_content(/^replSet = production$/)
      is_expected.to contain_class('mongodb::configure_replica_set').with_members({'mongo-box-1' => {}})
    end
  end

  describe "setting three replica set members" do
    let(:params) { {
      'version' => '2.0.7',
      'replicaset_members' => {
        'mongo-box-1' => {},
        'mongo-box-2' => {},
        'mongo-box-3' => {},
      },
    } }

    it do
      is_expected.to contain_file('/etc/mongodb.conf').with_content(/^replSet = production$/)
      is_expected.to contain_class('mongodb::configure_replica_set')
        .with_members({
        'mongo-box-1' => {},
        'mongo-box-2' => {},
        'mongo-box-3' => {},
      })
    end
  end

  describe "setting the oplog size" do
    let(:params) {{
      'version' => '2.0.7',
      'oplog_size' => '1234',
      'replicaset_members' => {'mongo-box-1' => {}},
    }}

    it do
      is_expected.to contain_file('/etc/mongodb.conf').with_content(/^oplogSize = 1234$/)
    end
  end
end
