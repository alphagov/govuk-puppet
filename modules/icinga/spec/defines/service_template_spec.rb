require_relative '../../../../spec_helper'

describe 'icinga::service_template', :type => :define do
  let(:title) { 'important_service' }
  let(:params) { {'contact_groups' => ['jims_friends','jims_enemies']}}
  it { should contain_file('/etc/icinga/conf.d/service_template_important_service.cfg').
    with_content(/name\s+important_service/).
    with_content(/contact_groups\s+jims_friends,jims_enemies/)
  }

end
