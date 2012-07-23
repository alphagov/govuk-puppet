require_relative '../../../../spec_helper'

describe 'nagios::contact_group', :type => :define do
  let(:title) { 'jims_friends' }
  let(:params) {{ "email" => "jims_friends@bar.invalid" }}
  it { should contain_file('/etc/nagios3/conf.d/contacts_nagios2.cfg').
    with_content(/jims_friends@bar\.invalid/)
  }
end
