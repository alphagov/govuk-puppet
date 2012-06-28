class nginx::config::elms {
  include nginx
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => 'puppet:///modules/nginx/elms',
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

  file { '/etc/nginx/htpasswd/htpasswd.elms':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.elms',
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

}
