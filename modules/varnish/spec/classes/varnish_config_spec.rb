require_relative '../../../../spec_helper'

describe 'varnish::config', :type => :class do
  context 'Varnish 2 on Ubuntu lucid' do
    let(:facts) {{ :lsbdistcodename => 'lucid' }}

    it { should contain_file('/etc/varnish/default.vcl').with_content(/^\s+purge\(/) }
    it { should contain_file('/etc/varnish/default.vcl').with_content(/^\s+set req\.hash/) }
  end

  context 'Varnish 3 on Ubuntu precise' do
    let(:facts) {{ :lsbdistcodename => 'precise' }}

    it { should contain_file('/etc/varnish/default.vcl').with_content(/^\s+ban\(/) }
    it { should contain_file('/etc/varnish/default.vcl').with_content(/^\s+hash_data\(/) }
  end
end
