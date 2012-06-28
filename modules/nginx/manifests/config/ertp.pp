class nginx::config::ertp {
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => 'puppet:///modules/nginx/ertp',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

  file { '/etc/nginx/htpasswd/htpasswd.ertp':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.ertp',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

}

class nginx::config::ertp::staging {
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => 'puppet:///modules/nginx/ertp-staging',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

  file { '/etc/nginx/htpasswd/htpasswd.ertp.staging':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.ertp.staging',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

}

class nginx::config::ertp::api::staging {
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => 'puppet:///modules/nginx/ertp-staging-api',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

  file { '/etc/nginx/htpasswd/htpasswd.ertp.api.staging':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.ertp.api.staging',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

}

class nginx::config::ertp::api::preview {
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => 'puppet:///modules/nginx/ertp-preview-api',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

  file { '/etc/nginx/htpasswd/htpasswd.ertp.api.preview':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.ertp.api.preview',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

}