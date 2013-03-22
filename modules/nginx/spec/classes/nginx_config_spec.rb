require_relative '../../../../spec_helper'

describe 'nginx::config', :type => :class do
  let(:file_path) { '/etc/nginx/nginx.conf' }

  let(:params) { { 'server_names_hash_max_size' => '1024' } }

  it { should contain_file(file_path).with_content(/server_names_hash_max_size 1024;/) }

  context 'Ubuntu lucid' do
    let(:facts) {{ :lsbdistcodename => 'lucid' }}
    it { should contain_file(file_path)
      .with_content(/^pid\s+\/var\/run\/nginx.pid;$/)
    }
  end

  context 'Ubuntu precise' do
    let(:facts) {{ :lsbdistcodename => 'precise' }}
    it { should contain_file(file_path)
      .with_content(/^pid\s+\/run\/nginx.pid;$/)
    }
  end
end
