# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::content_store::rabbitmq (
  $amqp_user  = 'content_store',
  $amqp_pass  = 'content_store',
  $amqp_exchange = 'published_documents',
  $configure_test_exchange = false,
) {


  rabbitmq_user { $amqp_user:
    password => $amqp_pass,
  }

  $permissions_regex_fragment = $configure_test_exchange ? {
    true    => "${amqp_exchange}|${amqp_exchange}_test",
    default => $amqp_exchange
  }

  rabbitmq_user_permissions { "${amqp_user}@/":
    configure_permission => '^amq\.gen.*$',
    read_permission      => "^(amq\\.gen.*|${permissions_regex_fragment})$",
    write_permission     => "^(amq\\.gen.*|${permissions_regex_fragment})$",
  }

  govuk_rabbitmq::exchange { "${amqp_exchange}@/":
    type     => 'topic',
  }

  if $configure_test_exchange {
    # Used for running integration tests.
    govuk_rabbitmq::exchange { "${amqp_exchange}_test@/":
      type     => 'topic',
    }
  }
}
