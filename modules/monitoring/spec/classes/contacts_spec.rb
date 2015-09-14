require_relative '../../../../spec_helper'

shared_examples 'configured contact groups' do |urgent, high, normal|
  it { is_expected.to contain_icinga__contact_group('urgent-priority').with(
    :members => urgent
  )}
  it { is_expected.to contain_icinga__contact_group('high-priority').with(
    :members => high
  )}
  it { is_expected.to contain_icinga__contact_group('normal-priority').with(
    :members => normal
  )}
end

describe 'monitoring::contacts', :type => :class do
  context 'param defaults' do
    it { is_expected.not_to contain_icinga__slack_contact('slack_notification') }

    it_should_behave_like 'configured contact groups',
      [],
      [],
      []
  end

  context 'notify_pager => true' do
    let(:params) {{
      :notify_pager => true,
    }}

    it { is_expected.not_to contain_icinga__slack_contact('slack_notification') }

    it_should_behave_like 'configured contact groups',
      ['pagerduty_24x7'],
      [],
      []
  end

  context 'notify_pager => true, notify_slack => true, slack creds' do
    let(:params) {{
      :notify_pager       => true,
      :notify_slack       => true,
      :slack_token        => 'peach',
      :slack_channel      => 'pear',
      :slack_subdomain    => 'plum',
    }}

    it { is_expected.to contain_icinga__slack_contact('slack_notification').with(
      :slack_token     => 'peach',
      :slack_channel   => 'pear',
      :slack_subdomain => 'plum'
    )}

    it_should_behave_like 'configured contact groups',
      ['slack_notification', 'pagerduty_24x7'],
      ['slack_notification'],
      ['slack_notification']
  end
end
