require_relative '../../../../spec_helper'

describe 'icinga::pagerduty_contact', :type => :define do
  let(:title) { '24x7' }
  let(:params) {{
    :pagerduty_servicekey => '1234554321',
  }}
  it { should contain_file('/etc/icinga/conf.d/contact_pagerduty_24x7.cfg').
    with_content(/command_name\s+notify-host-by-pagerduty/).
    with_content(/command_line\s+\/usr\/local\/bin\/pagerduty_icinga.pl\senqueue\s-f\spd_nagios_object=host/).
    with_content(/command_name\s+notify-service-by-pagerduty/).
    with_content(/command_line\s+\/usr\/local\/bin\/pagerduty_icinga.pl\senqueue\s-f\spd_nagios_object=service/).
    with_content(/service_notification_period\s+24x7/).
    with_content(/service_notification_options\s+w,u,c,r/).
    with_content(/pager\s+1234554321/)
  }
end
