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
# [*deny_crawlers*]
#   Boolean, whether the loadbalancer should serve a robots.txt that
#   prevents crawlers from indexing the thing being balanced.
#
# [*error_on_http*]
#   Whether we should serve an error for HTTP requests. Generally we
#   prefer to redirect from HTTP to HTTPS to provide a good user experience,
#   but for APIs and machine-only apps we can serve errors for HTTP connections.
#
# [*https_port*]
#   Port to listen on for HTTPS.
#   Default: 443
#
# [*https_redirect*]
#   Boolean, whether requests on port 80 should be redirected to HTTPS.
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
# [*maintenance_mode*]
#   Puts balancers into maintenance mode.
#
define loadbalancer::balance(
    $servers,
    $aliases = [],
    $deny_crawlers = false,
    $error_on_http = false,
    $https_port = 443,
    $https_redirect = true,
    $internal_only = false,
    $vhost = $title,
    $read_timeout = 15,
    $maintenance_mode = false,
    $modified_paths = {},
) {

  $vhost_suffix = hiera('app_domain')
  $vhost_real = "${vhost}.${vhost_suffix}"

  nginx::config::ssl { $vhost_real:
    certtype => 'wildcard_publishing',
  }

  nginx::config::site { $vhost_real:
    content => template('loadbalancer/nginx_balance.conf.erb'),
  }

  nginx::log {
    "${vhost_real}-json.event.access.log":
      json      => true,
      logstream => present;
    "${vhost_real}-error.log":
      logstream => present;
  }

  if ! defined(File['/etc/nginx/includes']) {
    file { '/etc/nginx/includes':
      ensure => 'directory',
    }
  }

  if ! defined(File['/etc/nginx/includes/maintenance.conf']) {
    file { '/etc/nginx/includes/maintenance.conf':
      ensure  => present,
      content => template('loadbalancer/etc/nginx/includes/maintenance.conf.erb'),
      require => File['/etc/nginx/includes'],
      notify  => Class['nginx::service'],
    }
  }

  #FIXME - This maintenance page is currently hardcoded with assets etc
  #        that it shouldn't be. Specific to migration. Should be changed
  #        after migration is completed.
  if ! defined(File['/usr/share/nginx/html/maintenance.html']) {
    file { '/usr/share/nginx/html/maintenance.html':
      ensure  => present,
      content => template('loadbalancer/usr/share/nginx/html/maintenance_page.erb'),
    }
  }
}
