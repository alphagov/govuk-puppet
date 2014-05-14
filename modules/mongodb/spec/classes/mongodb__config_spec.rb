require_relative '../../../../spec_helper'

describe 'mongodb::config', :type => :class do
  describe 'upstart config' do
    let(:params) {{
      :logpath     => '/this/is/a/path',
      :development => false,
    }}

    it {
      should contain_file('/etc/init/mongodb.conf').with_content(
/^\s*exec start-stop-daemon --start --quiet --chuid mongodb \
-p \/var\/lib\/mongodb\/mongod.lock --startas \/usr\/bin\/mongod -- \
--logpath "\/this\/is\/a\/path" --logappend --config "\/etc\/mongodb.conf"$/
      )
    }
  end

  describe 'mongodb.conf' do
    context 'defaults' do
      let(:params) {{
        :logpath     => '/unused',
        :development => false,
      }}

      it { should contain_file('/etc/mongodb.conf').with_content(/^replSet = production$/) }
      it { should contain_file('/etc/mongodb.conf').with_content(/^profile = 1$/) }
      it { should contain_file('/etc/mongodb.conf').without_content(/noprealloc|journal|nojournal/) }
    end

    context 'development => true' do
      let(:params) {{
        :logpath     => '/unused',
        :development => true,
      }}

      it { should contain_file('/etc/mongodb.conf').without_content(/replSet/) }
      it { should contain_file('/etc/mongodb.conf').with_content(/^profile = 2$/) }
      it { should contain_file('/etc/mongodb.conf').with_content(/noprealloc|journal|nojournal/) }
    end
  end
end
