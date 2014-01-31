require_relative '../../../../spec_helper'

describe 'icinga::contact_group', :type => :define do
  let(:title) { 'jims_friends' }
  let(:params) {{ "group_alias" => "Awesome Team", "members" => [ 'jim', 'bob' ]}}
  it { should contain_file('/etc/icinga/conf.d/contact_group_jims_friends.cfg').
    with_content(/contactgroup_name\s+jims_friends/).
    with_content(/alias\s+Awesome Team/).
    with_content(/members\s+jim,bob/)
  }
end
