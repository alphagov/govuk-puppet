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
  file { '/etc/nginx/ssl/www.preview.alphagov.co.uk.crt':
    ensure  => present,
    content => extlookup('www.preview.alphagov.co.uk_crt', ''),
  }
  file { '/etc/nginx/ssl/www.preview.alphagov.co.uk.key':
    ensure  => present,
    content => extlookup('www.preview.alphagov.co.uk_key', ''),
  }
}
