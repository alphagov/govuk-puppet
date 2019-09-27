# == Define: nginx::config::vhost::default
#
# Create a catchall vhost for Nginx.
#
# === Parameters
#
# [*extra_config*]
#   Raw Nginx config lines to insert into the vhost config.
#
# [*status*]
#   HTTP response code to return.
#   Default: 500
#
# [*status_message*]
#   HTTP response content to return.
#   Default: {"error": "Fell through to default vhost"}
#
# [*ssl_certtype*]
#   Type of SSL cert passed to nginx::config::ssl
#   Default: wildcard_publishing
#
define nginx::config::vhost::default(
  $extra_config = '',
  $status = '500',
  $status_message = "'{\"error\": \"Fell through to default vhost\"}\\n'",
  $ssl_certtype = 'wildcard_publishing',
) {

  # Whether to enable SSL. Used by template.
  $enable_ssl = hiera('nginx_enable_ssl', true)

  nginx::config::ssl { $title:
    certtype => $ssl_certtype,
  }

  # On AWS, we create an (initially empty) lb_healthchecks.conf and hook it
  # into the default vhost config. App classes add healthcheck routes to that
  # file so that ALBs can reach an app's healthcheck without the ability to
  # specify the Host header.
  # See https://github.com/alphagov/govuk-aws/blob/master/doc/architecture/decisions/0037-alb-health-checks.md
  if $::aws_migration {
    concat { '/etc/nginx/lb_healthchecks.conf':
      ensure => present,
    }
  }

  nginx::config::site { $title:
    content => template('nginx/default-vhost.conf'),
  }

}
