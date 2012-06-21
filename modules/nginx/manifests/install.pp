class nginx::install {
  include apt
  apt::ppa_repository { 'nginx_ppa':
    publisher => 'nginx',
    repo      => 'stable',
  }

  if $::govuk_class == 'frontend' {
    package { 'nginx':
      ensure  => '1.2.1-0ubuntu0ppa1~lucid',
      require => Exec['add_repo_nginx_ppa'],
    }
  } else {
    package { 'nginx':
      ensure  => 'installed',
      require => Exec['add_repo_nginx_ppa'],
    }
  }
  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify  => Exec['nginx_reload'],
  }
  file { '/etc/nginx/blockips.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/blockips.conf',
    require => Package['nginx'],
    notify  => Exec['nginx_reload'],
  }
  file { ['/var/www', '/var/www/cache']:
    ensure => directory,
    owner  => 'www-data',
  }
  file { '/usr/share/nginx':
    ensure  => directory,
  }
  file { '/usr/share/nginx/www':
    ensure  => directory,
    mode    => '0777',
    require => File['/usr/share/nginx'],
  }
  file { '/etc/nginx/htpasswd':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['nginx']
  }
  file { '/etc/nginx/ssl':
    ensure  => directory,
    require => Package['nginx'],
  }
}
