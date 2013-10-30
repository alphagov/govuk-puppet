require_relative '../../../../spec_helper'

describe 'icinga::contact', :type => :define do
  let(:params) {{ "service_notification_options" => 'c', "email"=>'a@b.com'}}
  it { should contain_file('/etc/icinga/conf.d/contact_contact_notification_options.cfg').
    with_content(/service_notification_options\s+c/)
  }
end

describe 'icinga::contact', :type => :define do
  let(:title) { 'notification_period' }
  let(:params) {{ "notification_period" => 'workhours', "email"=>'a@b.com'}}
  it { should contain_file('/etc/icinga/conf.d/contact_notification_period.cfg').
    with_content(/service_notification_period\s+workhours/).
    with_content(/host_notification_period\s+workhours/)
  }
end
