require_relative '../../../../spec_helper'

describe 'nagios::service_template', :type => :define do
  let(:title) { 'important_service' }
  it { should contain_file('/etc/nagios3/conf.d/service_template_important_service.cfg').
    with_content(/name\s+important_service/)
  }

end
