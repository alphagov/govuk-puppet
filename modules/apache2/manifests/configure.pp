File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}

class apache2::configure {

  file { '/etc/apache2/sites-available/default':
    ensure  => 'present',
    source  => 'puppet:///modules/apache2/000-default',
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/conf.d/localized-error-pages':
    ensure  => present,
    source  => 'puppet:///modules/apache2/localized-error-pages',
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/apache2.conf':
    ensure  => present,
    source  => 'puppet:///modules/apache2/apache2.conf',
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/envvars':
    ensure  => present,
    source  => 'puppet:///modules/apache2/envvars',
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/ports.conf':
    ensure  => present,
    content => template('apache2/ports.conf'),
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/conf.d/security':
    ensure  => present,
    source  => 'puppet:///modules/apache2/security',
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { '/data/vhost':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    mode    => '0755',
    require => User['deploy'],
  }
}
