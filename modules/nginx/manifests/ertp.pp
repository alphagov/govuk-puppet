class nginx::ertp {
  include nginx
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => 'puppet:///modules/nginx/ertp',
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

  file { '/etc/nginx/htpasswd/htpasswd.ertp':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.ertp',
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

}

class nginx::ertp::staging {
  include nginx
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => 'puppet:///modules/nginx/ertp-staging',
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

  file { '/etc/nginx/htpasswd/htpasswd.ertp.staging':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.ertp.staging',
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

}