# == Class: pact_broker
#
# Sets up and runs the pact-broker application
#
# === Parameters
#
# [*port*]
#   The port the application should run on
#
# [*vhost*]
#   The vhost name to configure in nginx
#
# [*ssl_cert*]
#   The ssl certificate file to use
#
# [*ssl_key*]
#   The ssl key file to use
#
# [*user*]
#   The user to run the app as
#
# [*deploy_dir*]
#   Where to deploy and run the app from
#
# [*auth_user*]
# [*auth_password*]
#   The HTTP Basic Auth user and password to be configured for all write
#   requests (all non-GET requests) to the app.
#
class pact_broker (
  $port = 3112,
  $vhost = 'pact-broker.dev.publishing.service.gov.uk',
  $ssl_cert = '/etc/ssl/certs/ssl-cert-snakeoil.pem',
  $ssl_key = '/etc/ssl/private/ssl-cert-snakeoil.key',
  $user = 'pact_broker',
  $deploy_dir = '/srv/pact_broker',
  $auth_user = 'pact_ci',
  $auth_password,
  $hosts,
) {

  include ::nginx
  include ::pact_broker::database
  contain ::govuk_rbenv::all

  # Pact_Broker vhost
  ::nginx::config::vhost::proxy { $vhost:
    to           => $hosts,
    ssl_only     => true,
    extra_config => 'add_header    Strict-Transport-Security "max-age=31536000";',
  }

  # User
  user { $user:
    home       => $deploy_dir,
    managehome => true,
  }

  # Application
  class { 'pact_broker::app':
    app_root => "${deploy_dir}/app",
    user     => $user,
    require  => User[$user],
  }

  class { 'pact_broker::service':
    deploy_dir    => $deploy_dir,
    user          => $user,
    port          => $port,
    auth_user     => $auth_user,
    auth_password => $auth_password,
    subscribe     => Class['pact_broker::app'],
    require       => Class['pact_broker::database'],
  }

  file { '/etc/logrotate.d/pact_broker':
    content => template('pact_broker/logrotate.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
