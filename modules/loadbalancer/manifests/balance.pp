# == Type: loadbalancer::balance
#
# Install a loadbalancer configuration for the specified hosts.
#
# By default, this will install an Nginx load balancing proxy configuration
# for "$title.$app_domain". You can specify additional server names to listen
# to using the `aliases` parameter.
#
# === Parameters
#
# [*servers*]
#   Array of IPs or hostname of the upstream servers.
#
# [*aliases*]
#   Additional server names for the loadbalanced service.
#
# [*https_only*]
#   Only serve the loadbalanced service over HTTPS.
#   Default: true
#
# [*internal_only*]
#   Limit access to the loadbalanced service to internal IP address only.
#   Default: false
#
# [*vhost*]
#   Name of the vhost.
#   Default: $title
#
# [*read_timeout*]
#   Pass to nginx's proxy_read_timeout setting.
#   Default: 15
#
define loadbalancer::balance(
    $servers,
    $aliases = [],
    $https_only = true,
    $internal_only = false,
    $vhost = $title,
    $read_timeout = 15,
) {

  $vhost_suffix = hiera('app_domain')
  $vhost_real = "${vhost}.${vhost_suffix}"

  nginx::config::ssl { $vhost_real:
    certtype => 'wildcard_alphagov',
  }

  nginx::config::site { $vhost_real:
    content => template('loadbalancer/nginx_balance.conf.erb'),
  }

  nginx::log {
    "${vhost_real}-json.event.access.log":
      json      => true,
      logstream => present;
    "${vhost_real}-access.log":
      logstream => absent;
    "${vhost_real}-error.log":
      logstream => present;
  }
}
