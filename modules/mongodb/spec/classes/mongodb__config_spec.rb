require_relative '../../../../spec_helper'

describe 'mongodb::config', :type => :class do
  describe 'mongodb.conf' do
    context 'defaults' do
      let(:params) {{
        :development => false,
        :replicaset_name  => 'production',
      }}

      it { should contain_file('/etc/mongodb.conf').with_content(/^replSet = production$/) }
      it { should contain_file('/etc/mongodb.conf').with_content(/^profile = 1$/) }
      it { should contain_file('/etc/mongodb.conf').without_content(/noprealloc|journal|nojournal/) }
    end

    context 'development => true' do
      let(:params) {{
        :development      => true,
        :replicaset_name  => 'development',
      }}

      it { should contain_file('/etc/mongodb.conf').with_content(/replSet = development$/) }
      it { should contain_file('/etc/mongodb.conf').with_content(/^profile = 2$/) }
      it { should contain_file('/etc/mongodb.conf').with_content(/noprealloc|journal|nojournal/) }
    end
  end
end
