require_relative '../../../../spec_helper'

describe 'govuk_rabbitmq::consumer', :type => :define do
  let(:title) { 'a_user' }

  let(:facts) {{
    staging_http_get: 'curl',
  }}

  context 'minimum info' do
    let(:params) {{
      :amqp_pass => 'super_secret',
      :amqp_exchange => 'an_exchange',
      :amqp_queue => 'a_queue',
      :routing_key => 'some routing key',
    }}

    it { is_expected.to contain_rabbitmq_user('a_user').with_password('super_secret') }

    it {
      is_expected.to contain_rabbitmq_queue('a_queue@/').with(
          :durable     => true,
          :auto_delete => false,
      )
    }

    it {
      is_expected.to contain_rabbitmq_binding('binding_some routing key_an_exchange@a_queue@/').with(
          :destination_type => 'queue',
          :routing_key      => 'some routing key',
      )
    }

    it {
      is_expected.to contain_rabbitmq_user_permissions('a_user@/').with(
        :configure_permission => '^(amq\.gen.*|a_queue)$',
        :write_permission => '^(amq\.gen.*|a_queue)$',
        :read_permission => '^(amq\.gen.*|a_queue|an_exchange)$',
      )
    }

    it { is_expected.not_to contain_govuk_rabbitmq__exchange }
  end

  context 'for a test exchange' do
    let(:params) {{
      :amqp_pass => 'super_secret',
      :amqp_exchange => 'an_exchange',
      :amqp_queue => 'a_queue',
      :routing_key => 'some routing key',
      :is_test_exchange => true,
    }}

    it { is_expected.to contain_govuk_rabbitmq__exchange('an_exchange@/').with_type('topic') }

    it {
      is_expected.to contain_rabbitmq_user_permissions('a_user@/').with(
        :configure_permission => '^(amq\.gen.*|a_queue)$',
        :write_permission => '^(amq\.gen.*|a_queue|an_exchange)$',
        :read_permission => '^(amq\.gen.*|a_queue|an_exchange)$',
      )
    }
  end

  context 'creating the test exchange with a non-default type' do
    let(:params) {{
      :amqp_pass => 'super_secret',
      :amqp_exchange => 'an_exchange',
      :amqp_queue => 'a_queue',
      :routing_key => 'some routing key',
      :is_test_exchange => true,
      :exchange_type => 'direct',
    }}

    it { is_expected.to contain_govuk_rabbitmq__exchange('an_exchange@/').with_type('direct') }
  end
end
