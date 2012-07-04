require_relative '../../../../spec_helper'

describe 'nginx', :type => :class do
  let(:params) { {'node_type' => 'redirect'} } 
  let(:name) { 'blah' }   
    
  it { should contain_package('nginx').with({
      'ensure'  => '1.2.1-1ubuntu0ppa2~lucid'
  })}

  # it { should contain_file('/etc/nginx/sites-available/blah').without_mode }
end
