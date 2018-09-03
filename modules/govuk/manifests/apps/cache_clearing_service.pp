# == Class: govuk::apps::cache_clearing_service
#
# This is a message queue consumer application which clears Fastly and Varnish
# caches when new content is published.
#
# === Parameters
#
# [*enabled*]
#   Should the application should be enabled. Set in hiera data for each
#   environment.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*rabbitmq_hosts*]
#   RabbitMQ hosts to connect to.
#   Default: localhost
#
# [*rabbitmq_user*]
#   RabbitMQ username.
#   Default: cache_clearing_service
#
# [*rabbitmq_password*]
#   RabbitMQ password.
#   Default: cache_clearing_service
#
# [*puppetdb_node_url*]
#   The `nodes` endpoint URL for Puppet DB
#
class govuk::apps::cache_clearing_service (
  $enabled = false,
  $sentry_dsn = undef,
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_user = 'cache_clearing_service',
  $rabbitmq_password = 'cache_clearing_service',
  $puppetdb_node_url = undef,
) {
  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  $app_name = 'cache-clearing-service'

  govuk::app { $app_name:
    ensure             => $ensure,
    app_type           => 'bare',
    enable_nginx_vhost => false,
    sentry_dsn         => $sentry_dsn,
    command            => './bin/cache_clearing_service',
  }

  Govuk::App::Envvar {
    ensure          => $ensure,
    app             => $app_name,
    notify_service  => $enabled,
  }

  govuk::app::envvar::rabbitmq { $app_name:
    hosts    => $rabbitmq_hosts,
    user     => $rabbitmq_user,
    password => $rabbitmq_password,
  }

  if $::aws_migration {
    govuk::app::envvar { "${title}-AWS_STACKNAME":
      varname => 'AWS_STACKNAME',
      value   => $::aws_stackname;
    }
  } else {
    govuk::app::envvar { "${title}-PUPPETDB_NODE_URL":
      varname => 'PUPPETDB_NODE_URL',
      value   => $puppetdb_node_url;
    }
  }
}
