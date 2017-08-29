require_relative '../../../../spec_helper'

describe 'govuk_rabbitmq::consumer', :type => :define do
  let(:title) { 'a_user' }

  let(:facts) {{
    staging_http_get: 'curl',
  }}

  context 'multiple queues' do
    let(:params) {{
      :amqp_pass => 'super_secret',
      :amqp_exchange => 'an_exchange',
      :amqp_queue => 'a_queue',
      :routing_key => 'some routing key',
      :amqp_queue_2 => 'a_second_queue',
      :routing_key_2 => 'another routing key',
    }}

    it { is_expected.to contain_rabbitmq_user('a_user').with_password('super_secret') }

    it {
      is_expected.to contain_rabbitmq_queue('a_queue@/').with(
          :durable     => true,
          :auto_delete => false,
      )
      is_expected.to contain_rabbitmq_queue('a_second_queue@/').with(
          :durable     => true,
          :auto_delete => false,
      )
    }

    it {
      is_expected.to contain_rabbitmq_binding('binding_some routing key_an_exchange@a_queue@/').with(
          :destination_type => 'queue',
          :routing_key      => 'some routing key',
      )
      is_expected.to contain_rabbitmq_binding('binding_another routing key_an_exchange@a_second_queue@/').with(
          :destination_type => 'queue',
          :routing_key      => 'another routing key',
      )
    }

    context 'when create_queue is false' do
      let(:params) {{
        :amqp_pass => 'super_secret',
        :amqp_exchange => 'an_exchange',
        :amqp_queue => 'a_queue',
        :routing_key => 'some routing key',
        :amqp_queue_2 => 'a_second_queue',
        :routing_key_2 => 'another routing key',
        :create_queue => false
      }}

      it {
        is_expected.not_to contain_rabbitmq_queue('a_queue@/')
        is_expected.not_to contain_rabbitmq_queue('a_second_queue@/')
      }
    end

    it {
      is_expected.to contain_rabbitmq_user_permissions('a_user@/').with(
        :configure_permission => '^(amq\.gen.*|a_queue|a_second_queue)$',
        :write_permission => '^(amq\.gen.*|a_queue|a_second_queue)$',
        :read_permission => '^(amq\.gen.*|a_queue|a_second_queue|an_exchange)$',
      )
    }

    it { is_expected.not_to contain_govuk_rabbitmq__exchange }
  end

  context 'missing routing key' do
    let(:params) {{
      :amqp_pass => 'super_secret',
      :amqp_exchange => 'an_exchange',
      :amqp_queue => 'a_queue',
      :routing_key => '',
      }}

      it { is_expected.to raise_error(Puppet::Error, /\$routing_key must be non-empty/) }
  end

  context 'missing routing key for optional queue' do
    let(:params) {{
      :amqp_pass => 'super_secret',
      :amqp_exchange => 'an_exchange',
      :amqp_queue => 'a_queue',
      :routing_key => 'some routing key',
      :amqp_queue_2 => 'a_second_queue',
      :routing_key_2 => '',
      }}

      it { is_expected.to raise_error(Puppet::Error, /\$routing_key_2 must be non-empty/) }
  end

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
