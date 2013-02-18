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
#   Default: false
#
# [*internal_only*]
#   Limit access to the loadbalanced service to internal IP address only.
#   Default: false
#
define loadbalancer::balance(
    $servers,
    $aliases = [],
    $https_only = false,
    $internal_only = false,
    $vhost = $title
) {

  $vhost_suffix = extlookup('app_domain')
  $vhost_real = "${vhost}.${vhost_suffix}"

  nginx::config::ssl { $vhost_real:
    certtype => 'wildcard_alphagov',
  }

  nginx::config::site { $vhost_real:
    content => template('loadbalancer/nginx_balance.conf.erb'),
  }

  nginx::log { [
                "${vhost_real}-access.log",
                "${vhost_real}-error.log",
                ]:
  }
}
