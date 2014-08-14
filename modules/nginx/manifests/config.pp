class nginx::config (
  $server_names_hash_max_size,
  $denied_ip_addresses) {

  file { '/etc/nginx':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/nginx/etc/nginx';
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
  # replaced by nginx::conf above
  file { '/etc/nginx/sts.conf':
    ensure => absent,
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

  file { '/var/www/error':
    ensure  => directory,
    source  => 'puppet:///modules/nginx/error',
    purge   => true,
    recurse => true,
    force   => true,
    require => File['/var/www'],
  }

  @@icinga::check::graphite { "check_nginx_active_connections_${::hostname}":
    target    => "${::fqdn_underscore}.nginx.nginx_connections-active",
    warning   => 500,
    critical  => 1000,
    desc      => 'nginx high active conn',
    host_name => $::fqdn,
  }

}
