require_relative '../../../../spec_helper'

describe 'govuk_rabbitmq::consumer', :type => :define do
  let(:title) { 'a_user' }

  let(:facts) {{
    staging_http_get: 'curl',
  }}

  let(:params) {{
    :amqp_pass => 'super_secret',
    :read_permission  => '.*',
    :write_permission => '^$',
    :configure_permission => '^a_queue$'
  }}

  it { is_expected.to contain_rabbitmq_user('a_user').with_password('super_secret') }

  it {
    is_expected.to contain_rabbitmq_user_permissions('a_user@/').with(
      :configure_permission => '^a_queue$',
      :write_permission => '^$',
      :read_permission => '.*',
    )
  }
end
