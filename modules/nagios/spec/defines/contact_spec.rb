require_relative '../../../../spec_helper'

describe 'nagios::contact', :type => :define do
  let(:title) { 'jim' }
  let(:params) {{ "email" => "jimisawesome@invalid.domain"}}
  it { should contain_file('/etc/nagios3/conf.d/contact_jim.cfg').
    with_content(/contact_name\s+jim/).
    with_content(/email\s+jimisawesome@invalid.domain/)
  }
end

describe 'nagios::contact', :type => :define do
  let(:title) { 'contact_notification_options' }
  let(:params) {{ "service_notification_options" => 'c', "email"=>'a@b.com'}}
  it { should contain_file('/etc/nagios3/conf.d/contact_contact_notification_options.cfg').
    with_content(/service_notification_options\s+c/)
  }
end

describe 'nagios::contact', :type => :define do
  let(:title) { 'notification_period' }
  let(:params) {{ "notification_period" => 'workhours', "email"=>'a@b.com'}}
  it { should contain_file('/etc/nagios3/conf.d/contact_notification_period.cfg').
    with_content(/service_notification_period\s+workhours/).
    with_content(/host_notification_period\s+workhours/)
  }
end

describe 'nagios::contact', :type => :define do
  let(:title) { 'pager_nonworkhours' }
  let(:params) {{ "config_template" => "nagios/pager_nonworkhours.cfg.erb", "notification_period" => 'workhours', "email"=>'a@b.com'}}
  it { should contain_file('/etc/nagios3/conf.d/contact_pager_nonworkhours.cfg').
    with_content(/command_name\s+notify-host-by-pagerduty/).
    with_content(/command_line\s+\/usr\/local\/bin\/pagerduty_nagios.pl\senqueue\s-f\spd_nagios_object=host/).
    with_content(/command_name\s+notify-service-by-pagerduty/).
    with_content(/command_line\s+\/usr\/local\/bin\/pagerduty_nagios.pl\senqueue\s-f\spd_nagios_object=service/).    
    with_content(/service_notification_period\s+workhours/)

  }
end
