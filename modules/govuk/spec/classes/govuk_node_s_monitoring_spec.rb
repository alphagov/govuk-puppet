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

# NB: The reason these tests are more likley to fail than any other is
# because they include a node class, which in turn includes `s_base` and
# *everything* else. Because `govuk_nodes_spec_optional` is currently broken
# this is our only canary for ensures that modules play nicely together.
describe 'govuk::node::s_monitoring', :type => :class do
  # Set FQDN to satisfy other tests, like the `hosts` module
  let(:node) { 'monitoring-1.management.somethingsomething' }

  let (:hiera_data) {{
      'app_domain'            => 'giraffe.biz',
      'asset_root'            => 'https://static.test.gov.uk',
      'website_root'          => 'www.giraffe.biz',
      'aws_ses_smtp_host'     => 'email-smtp.aws.example.com',
      'aws_ses_smtp_username' => 'a_username',
      'aws_ses_smtp_password' => 'a_password',
    }}

  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat/'}}

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
