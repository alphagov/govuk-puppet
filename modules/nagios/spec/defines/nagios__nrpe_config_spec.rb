require_relative '../../../../spec_helper'

describe 'nagios::nrpe_config', :type => :define do
  let(:title) { 'parrot' }
  let(:params) { {:content => 'parrot content'} }

  it do
    should contain_file('/etc/nagios/nrpe.d/parrot.cfg').with_content('parrot content')
  end
end
