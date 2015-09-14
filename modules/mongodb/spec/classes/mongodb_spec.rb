require_relative '../../../../spec_helper'

describe 'mongodb::server', :type => :class do
  describe "with the default package name" do
    let(:params) { {
      'version' => '2.4.6',
      'replicaset_members' => ['mongo-box-1'],
     } }
    it do
      is_expected.to contain_package('mongodb-10gen').with_ensure('2.4.6')
      is_expected.to contain_file('/etc/mongodb.conf')
    end
  end

  describe "overriding the package name" do
    let(:params) { {
      'version' => '2.0.7',
      'package_name' => 'mongodb20-10gen',
      'replicaset_members' => ['mongo-box-1'],
    } }

    it do
      is_expected.to contain_package('mongodb20-10gen').with_ensure('2.0.7')
      is_expected.to contain_file('/etc/mongodb.conf')
    end
  end

  describe "not setting the replica set members" do
    let(:params) { {
      'version' => '2.0.7',
      'package_name' => 'mongodb20-10gen',
    } }

    it do
      is_expected.to raise_error(Puppet::Error, /^Replica set can't have no members/)
    end
  end

  describe "replica set can have one member" do
    let(:params) { {
      'version' => '2.0.7',
      'package_name' => 'mongodb20-10gen',
      'replicaset_members' => ['mongo-box-1'],
    } }

    it do
      is_expected.to contain_file('/etc/mongodb.conf').with_content(/^replSet = production$/)
      is_expected.to contain_class('mongodb::configure_replica_set').with_members('mongo-box-1')
    end
  end

  describe "setting three replica set members" do
    let(:params) { {
      'version' => '2.0.7',
      'package_name' => 'mongodb20-10gen',
      'replicaset_members' => ['mongo-box-1', 'mongo-box-2', 'mongo-box-3'],
    } }

    it do
      is_expected.to contain_file('/etc/mongodb.conf').with_content(/^replSet = production$/)
      is_expected.to contain_class('mongodb::configure_replica_set')
        .with_members(['mongo-box-1', 'mongo-box-2', 'mongo-box-3'])
    end
  end

  describe "setting the oplog size" do
    let(:params) {{
      'version' => '2.0.7',
      'oplog_size' => '1234',
      'package_name' => 'mongodb20-10gen',
      'replicaset_members' => ['mongo-box-1'],
    }}

    it do
      is_expected.to contain_file('/etc/mongodb.conf').with_content(/^oplogSize = 1234$/)
    end
  end
end
