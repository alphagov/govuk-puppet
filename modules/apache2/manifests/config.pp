class apache2::config($port) {

  apache2::a2enmod { 'headers': }
  apache2::a2dismod { 'status': }

  file { ['/etc/apache2/sites-enabled', '/etc/apache2/sites-available']:
    ensure  => directory,
    recurse => true, # enable recursive directory management
    purge   => true, # purge all unmanaged junk
    force   => true, # also purge subdirs and links etc.
  }

  file { '/etc/apache2/sites-available/default':
    ensure  => 'present',
    source  => 'puppet:///modules/apache2/000-default',
  }

  file { '/etc/apache2/conf.d/localized-error-pages':
    ensure  => present,
    source  => 'puppet:///modules/apache2/localized-error-pages',
  }

  file { '/etc/apache2/apache2.conf':
    ensure  => present,
    source  => 'puppet:///modules/apache2/apache2.conf',
  }

  file { '/etc/apache2/envvars':
    ensure  => present,
    source  => 'puppet:///modules/apache2/envvars',
  }

  file { '/etc/apache2/ports.conf':
    ensure  => present,
    content => template('apache2/ports.conf'),
  }

  file { '/etc/apache2/conf.d/security':
    ensure  => present,
    source  => 'puppet:///modules/apache2/security',
  }

  file { '/data/vhost':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    require => [User['deploy'], Group['deploy']],
  }
}
