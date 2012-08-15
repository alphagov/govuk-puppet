require_relative '../../../../spec_helper'


describe 'nagios::pager_contact', :type => :define do
  let(:title) { 'pager_nonworkhours' }
  it { should contain_file('/etc/nagios3/conf.d/contact_pager_nonworkhours.cfg').
    with_content(/command_name\s+notify-host-by-pagerduty/).
    with_content(/command_line\s+\/usr\/local\/bin\/pagerduty_nagios.pl\senqueue\s-f\spd_nagios_object=host/).
    with_content(/command_name\s+notify-service-by-pagerduty/).
    with_content(/command_line\s+\/usr\/local\/bin\/pagerduty_nagios.pl\senqueue\s-f\spd_nagios_object=service/).    
    with_content(/service_notification_period\s+24x7/)
  }
end
