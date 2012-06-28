class nginx::config::elms {
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => 'puppet:///modules/nginx/elms',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

  file { '/etc/nginx/htpasswd/htpasswd.elms':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.elms',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

}
