class graphite::config {
  file { '/var/log/graphite':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/opt/graphite/graphite/local-settings.py':
    source  => 'puppet:///modules/graphite/local_settings.py',
    require => [Package[python-graphite-web], Package[python-carbon]]
  }

  file { '/opt/graphite/conf/carbon.conf':
    source  => 'puppet:///modules/graphite/carbon.conf',
    require => [Package[python-graphite-web], Package[python-carbon]]
  }

  file { '/opt/graphite/conf/storage-schemas.conf':
    source  => 'puppet:///modules/graphite/storage-schema.conf',
    require => [Package[python-graphite-web], Package[python-carbon]]
  }

  file { '/opt/graphite/graphite/manage.py':
    mode    => '0755',
    require => Package[python-graphite-web]
  }

  file { '/opt/graphite/storage':
    mode    => '0755',
    recurse => true,
    group   => 'root',
    owner   => 'root',
    require => Package[python-graphite-web]
  }

  file{ '/opt/graphite/storage/log/webapp':
    ensure  => 'directory',
    require => File['/opt/graphite/storage']
  }

  file{ '/etc/graphite':
    ensure  => 'directory',
  }

  file{ '/etc/graphite/htpasswd.graphite':
    source  => 'puppet:///modules/graphite/htpasswd.graphite',
    require => File['/etc/graphite']
  }

  file { '/etc/apache2/mods-enabled/rewrite.load':
    ensure  => link,
    target  => '/etc/apache2/mods-available/rewrite.load',
    require => Package[apache2]
  }

  exec { 'create whisper db for graphite' :
    command     => '/opt/graphite/graphite/manage.py syncdb --noinput',
    require     => [Package[python-whisper],File['/opt/graphite/graphite/manage.py']],
    creates     => '/opt/graphite/storage/graphite.db',
    environment => ['GRAPHITE_STORAGE_DIR=/opt/graphite/storage/','GRAPHITE_CONF_DIR=/opt/graphite/conf/']
  }

  file { '/etc/apache2/sites-available/graphite':
    ensure  => 'present',
    source  => 'puppet:///modules/graphite/apache.conf',
    require => Class['apache2::install'],
  }

  file { '/etc/apache2/sites-enabled/graphite':
    ensure  => link,
    target  => '/etc/apache2/sites-available/graphite',
    require => File['/etc/apache2/sites-available/graphite'],
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/sites-enabled/000-default':
    ensure  => 'absent',
    require => File['/etc/apache2/sites-enabled/graphite'],
    notify  => Service['apache2'],
  }

}
