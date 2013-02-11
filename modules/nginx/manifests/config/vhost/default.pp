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
#   Default: wildcard_alphagov
#
# [*healthcheck*]
#   URI which will always return 200 responses.
#   Can be set to `false` to disable this functionality.
#   Default: /healthcheck
#
define nginx::config::vhost::default(
  $extra_config = '',
  $status = '500',
  $status_message = "'{\"error\": \"Fell through to default vhost\"}\\n'",
  $ssl_certtype = 'wildcard_alphagov',
  $healthcheck = '/healthcheck'
) {

  # Whether to enable SSL. Used by template.
  $enable_ssl = str2bool(extlookup('nginx_enable_ssl', 'yes'))

  nginx::config::ssl { $title:
    certtype => $ssl_certtype,
  }

  nginx::config::site { $title:
    content => template('nginx/default-vhost.conf'),
  }

}
