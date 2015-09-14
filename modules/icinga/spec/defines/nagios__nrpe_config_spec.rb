require_relative '../../../../spec_helper'

describe 'icinga::nrpe_config', :type => :define do
  let(:title) { 'parrot' }
  let(:params) { {:content => 'parrot content'} }

  it do
    is_expected.to contain_file('/etc/nagios/nrpe.d/parrot.cfg').with_content('parrot content')
  end
end
