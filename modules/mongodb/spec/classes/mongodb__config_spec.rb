require_relative '../../../../spec_helper'

describe 'mongodb::config', :type => :class do
  describe 'mongodb.conf' do
    context 'defaults' do
      let(:params) {{
        :development => false,
        :replicaset_name  => 'production',
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
      }}

      it { is_expected.to contain_file('/etc/mongodb.conf').with_content(/replSet = development$/) }
      it { is_expected.to contain_file('/etc/mongodb.conf').with_content(/^profile = 2$/) }
      it { is_expected.to contain_file('/etc/mongodb.conf').with_content(/noprealloc|journal|nojournal/) }
    end
  end
end
