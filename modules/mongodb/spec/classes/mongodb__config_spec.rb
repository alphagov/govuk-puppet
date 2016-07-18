require_relative '../../../../spec_helper'

describe 'mongodb::config', :type => :class do
  describe 'mongodb.conf' do
    context 'defaults' do
      let(:params) {{
        :development => false,
        :replicaset_name  => 'production',
        :config_filename => '/etc/mongodb.conf',
        :template_name => 'mongodb.conf'
      }}

      it { is_expected.to contain_file('/etc/mongodb.conf').with_content(/^replSet = production$/) }
      it { is_expected.to contain_file('/etc/mongodb.conf').with_content(/^profile = 1$/) }
      it { is_expected.to contain_file('/etc/mongodb.conf').without_content(/noprealloc|journal|nojournal/) }
      it { is_expected.to contain_file('/etc/mongodb.conf').without_content(/^oplogSize =/) }
    end

    context 'development => true' do
      let(:params) {{
        :development      => true,
        :replicaset_name  => 'development',
        :config_filename => '/etc/mongodb.conf',
        :template_name => 'mongodb.conf'
      }}

      it { is_expected.to contain_file('/etc/mongodb.conf').with_content(/replSet = development$/) }
      it { is_expected.to contain_file('/etc/mongodb.conf').with_content(/^profile = 2$/) }
      it { is_expected.to contain_file('/etc/mongodb.conf').with_content(/noprealloc|journal|nojournal/) }
    end
  end

  describe 'mongod.conf' do
    context 'defaults' do
      let(:params) {{
          :development => false,
          :replicaset_name  => 'production',
          :config_filename => '/etc/mongod.conf',
          :oplog_size => '7168 # 7 * 1024',
          :template_name => 'mongod.conf.erb'
      }}

      it { is_expected.to contain_file('/etc/mongod.conf').with_content(/^replication:\n\s\soplogSizeMB:\s7168 # 7 \* 1024\n\s\sreplSetName:\sproduction/) }
      it { is_expected.to contain_file('/etc/mongod.conf').with_content(/\s\sprofile: 1/) }
      it { is_expected.to contain_file('/etc/mongod.conf').with_content(/\s\sjournal:\n\s\s\s\senabled: true/) }
    end

    context 'development => true' do
      let(:params) {{
          :development => true,
          :replicaset_name  => 'development',
          :config_filename => '/etc/mongod.conf',
          :oplog_size => '7168 # 7 * 1024',
          :template_name => 'mongod.conf.erb'
      }}

      it { is_expected.to contain_file('/etc/mongod.conf').with_content(/^replication:\n\s\soplogSizeMB:\n\s\sreplSetName:\sdevelopment/) }
      it { is_expected.to contain_file('/etc/mongod.conf').with_content(/\s\sprofile: 2/) }
      it { is_expected.to contain_file('/etc/mongod.conf').with_content(/\s\sjournal:\n\s\s\s\senabled: false/) }
    end

  end

end
