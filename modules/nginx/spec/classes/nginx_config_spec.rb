require_relative '../../../../spec_helper'

describe 'nginx::config', :type => :class do
  let(:file_path) { '/etc/nginx/nginx.conf' }
  let(:default_params) {{
    :server_names_hash_max_size => '512',
    :denied_ip_addresses => []
  }}

  describe 'server_names_has_max_size' do
    let(:params) { default_params.merge({ 
      :server_names_hash_max_size => '1024'
    }) }

    it { should contain_file(file_path).with_content(/server_names_hash_max_size 1024;/) }
  end

  context 'Ubuntu lucid' do
    let(:params) { default_params }
    let(:facts) {{ :lsbdistcodename => 'lucid' }}

    it { should contain_file(file_path)
      .with_content(/^pid\s+\/var\/run\/nginx.pid;$/)
    }
  end

  context 'Ubuntu precise' do
    let(:params) { default_params }
    let(:facts) {{ :lsbdistcodename => 'precise' }}

    it { should contain_file(file_path)
      .with_content(/^pid\s+\/run\/nginx.pid;$/)
    }
  end

  context 'denied_ip_addresses' do
    let(:params) { default_params.merge({ 
      :denied_ip_addresses => [ '127.0.0.1' ] 
    })}
    it { should contain_file('/etc/nginx/blockips.conf')
      .with_content(<<EOS
deny 127.0.0.1;
EOS
    )}
  end
    
end
