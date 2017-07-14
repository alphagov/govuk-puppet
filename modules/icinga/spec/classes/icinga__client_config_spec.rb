require_relative '../../../../spec_helper'

describe 'icinga::client::config', :type => :class do
  context 'when allowed_hosts is not set' do
    it { is_expected.to contain_file('/etc/nagios/nrpe.cfg').with_content(/allowed_hosts=alert\.cluster,monitoring/) }
  end

  context 'when allowed_hosts is set' do
    let (:params) {{
      'allowed_hosts' => '1.2.3.4'
    }}
    it { is_expected.to contain_file('/etc/nagios/nrpe.cfg').with_content(/allowed_hosts=1\.2\.3\.4/) }
  end
end
