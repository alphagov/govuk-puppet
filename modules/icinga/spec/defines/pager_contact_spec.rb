require_relative '../../../../spec_helper'


describe 'icinga::pager_contact', :type => :define do
  let(:title) { 'pager_nonworkhours' }
  let(:params) {{
    :pagerduty_apikey => '1234554321',
  }}
  it { should contain_file('/etc/icinga/conf.d/contact_pager_nonworkhours.cfg').
    with_content(/command_name\s+notify-host-by-pagerduty/).
    with_content(/command_line\s+\/usr\/local\/bin\/pagerduty_nagios.pl\senqueue\s-f\spd_nagios_object=host/).
    with_content(/command_name\s+notify-service-by-pagerduty/).
    with_content(/command_line\s+\/usr\/local\/bin\/pagerduty_nagios.pl\senqueue\s-f\spd_nagios_object=service/).
    with_content(/service_notification_period\s+24x7/).
    with_content(/pager\s+1234554321/)
  }
end
