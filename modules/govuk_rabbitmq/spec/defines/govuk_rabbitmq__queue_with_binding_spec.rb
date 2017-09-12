require_relative '../../../../spec_helper'

describe 'govuk_rabbitmq::queue_with_binding', :type => :define do
  let(:title) { 'a_user' }

  let(:facts) {{
    staging_http_get: 'curl',
  }}

  context 'missing routing key' do
    let(:params) {{
      :amqp_exchange => 'an_exchange',
      :amqp_queue => 'a_queue',
      :routing_key => '',
      }}

    it { is_expected.to raise_error(Puppet::Error, /\$routing_key must be non-empty/) }
  end

  context 'minimum info' do
    let(:params) {{
      :amqp_exchange => 'an_exchange',
      :amqp_queue => 'a_queue',
      :routing_key => 'some routing key',
    }}

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
  end
end
