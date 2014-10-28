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

describe 'monitoring::contacts', :type => :class do
  context 'param defaults' do
    it { should_not contain_icinga__slack_contact('slack_notification') }

    it_should_behave_like 'configured contact groups',
      ['monitoring_google_group'],
      ['monitoring_google_group'],
      ['monitoring_google_group']
  end

  context 'notify_pager => true' do
    let(:params) {{
      :notify_pager => true,
    }}

    it { should_not contain_icinga__slack_contact('slack_notification') }

    it_should_behave_like 'configured contact groups',
      ['monitoring_google_group', 'pager_nonworkhours'],
      ['monitoring_google_group'],
      ['monitoring_google_group']
  end

  context 'notify_pager => true, notify_slack => true, slack creds' do
    let(:params) {{
      :notify_pager       => true,
      :notify_slack       => true,
      :slack_token        => 'peach',
      :slack_channel      => 'pear',
      :slack_subdomain    => 'plum',
    }}

    it { should contain_icinga__slack_contact('slack_notification').with(
      :slack_token     => 'peach',
      :slack_channel   => 'pear',
      :slack_subdomain => 'plum'
    )}

    it_should_behave_like 'configured contact groups',
      ['monitoring_google_group', 'slack_notification', 'pager_nonworkhours'],
      ['monitoring_google_group', 'slack_notification'],
      ['monitoring_google_group', 'slack_notification']
  end
end
