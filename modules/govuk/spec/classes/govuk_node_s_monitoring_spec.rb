require_relative '../../../../spec_helper'

shared_examples 'configured contact groups' do |urgent, high, normal|
  it { should contain_icinga__contact_group('urgent-priority').with(
    :members => urgent
  )}
  it { should contain_icinga__contact_group('high-priority').with(
    :members => high
  )}
  it { should contain_icinga__contact_group('normal-priority').with(
    :members => normal
  )}
end

describe 'govuk::node::s_monitoring', :type => :class do
  let (:hiera_data) {{
      'app_domain'   => 'giraffe.biz',
      'asset_root'   => 'https://static.test.gov.uk',
      'website_root' => 'www.giraffe.biz',
    }}

  context 'param defaults' do
    it { should_not contain_icinga__campfire_contact('campfire_notification') }

    it_should_behave_like 'configured contact groups',
      ['monitoring_google_group'],
      ['monitoring_google_group'],
      ['monitoring_google_group']
  end

  context 'notify_pager => true' do
    let(:params) {{
      :notify_pager => true,
    }}

    it { should_not contain_icinga__campfire_contact('campfire_notification') }

    it_should_behave_like 'configured contact groups',
      ['monitoring_google_group', 'pager_nonworkhours'],
      ['monitoring_google_group'],
      ['monitoring_google_group']
  end

  context 'notify_pager => true, notify_campfire => true, campfire creds' do
    let(:params) {{
      :notify_pager       => true,
      :notify_campfire    => true,
      :campfire_token     => 'peach',
      :campfire_room      => 'pear',
      :campfire_subdomain => 'plum',
    }}

    it { should contain_icinga__campfire_contact('campfire_notification').with(
      :campfire_token     => 'peach',
      :campfire_room      => 'pear',
      :campfire_subdomain => 'plum'
    )}

    it_should_behave_like 'configured contact groups',
      ['monitoring_google_group', 'campfire_notification', 'pager_nonworkhours'],
      ['monitoring_google_group', 'campfire_notification'],
      ['monitoring_google_group', 'campfire_notification']
  end
end
