# == Class: nginx::config
#
# This class sets up webserver configuration.
#
# === Parameters
#
# [*server_names_hash_max_size*]
#   An integer that sets the maximum size of the server_names_hash_max_size directive.
#
# [*variables_hash_max_size*]
#   An integer that sets the maximum size of the Nginx variables hash table.
#
# [*denied_ip_addresses*]
#   An array of IP addresses that Nginx should prevent from accessing this machine.
#
class nginx::config (
  $server_names_hash_max_size,
  $variables_hash_max_size = 1024,
  $denied_ip_addresses) {

  file { '/etc/nginx':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/nginx/etc/nginx';
  }

  file { '/etc/nginx/ssl':
    ensure  => directory,
    purge   => true,
    recurse => true,
    require => File['/etc/nginx'],
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    content => template('nginx/etc/nginx/nginx.conf.erb'),
  }

  file { '/etc/nginx/blockips.conf':
    ensure  => present,
    content => template('nginx/etc/nginx/blockips.conf.erb'),
  }

  nginx::conf {'nginx-status':
    source => 'puppet:///modules/nginx/nginx-status.conf',
  }

  nginx::conf {'map-sts':
    source => 'puppet:///modules/nginx/map-sts.conf',
  }

  file { ['/etc/nginx/sites-enabled', '/etc/nginx/sites-available', '/etc/nginx/conf.d']:
    ensure  => directory,
    recurse => true, # enable recursive directory management
    purge   => true, # purge all unmanaged junk
    force   => true, # also purge subdirs and links etc.
    require => File['/etc/nginx'];
  }

  file { '/etc/nginx/mime.types':
    ensure  => present,
    source  => 'puppet:///modules/nginx/etc/nginx/mime.types',
    require => File['/etc/nginx'],
    notify  => Class['nginx::service'];
  }

  file { ['/var/www', '/var/www/cache']:
    ensure => directory,
    owner  => 'www-data',
  }

  @@icinga::check::graphite { "check_nginx_active_connections_${::hostname}":
    target    => "${::fqdn_metrics}.nginx.nginx_connections-active",
    warning   => 500,
    critical  => 1000,
    desc      => 'nginx high active conn',
    host_name => $::fqdn,
  }

}
