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
