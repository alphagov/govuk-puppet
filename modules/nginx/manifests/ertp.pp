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

class nginx::ertp::api::staging {
  include nginx
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => 'puppet:///modules/nginx/ertp-staging-api',
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

  file { '/etc/nginx/htpasswd/htpasswd.ertp.api.staging':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.ertp.api.staging',
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

}

class nginx::ertp::api::preview {
  include nginx
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => 'puppet:///modules/nginx/ertp-preview-api',
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

  file { '/etc/nginx/htpasswd/htpasswd.ertp.api.preview':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.ertp.api.preview',
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

}