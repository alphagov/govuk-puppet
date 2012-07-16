class graphite::config {
  file { '/opt/graphite/graphite/local-settings.py':
    source  => 'puppet:///modules/graphite/local_settings.py',
  }

  file { '/opt/graphite/conf/carbon.conf':
    source  => 'puppet:///modules/graphite/carbon.conf',
  }

  file { '/opt/graphite/conf/storage-schemas.conf':
    source  => 'puppet:///modules/graphite/storage-schema.conf',
  }

  file { '/opt/graphite/storage':
    mode    => '0755',
    group   => 'root',
    owner   => 'root',
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
  }

  exec { 'create whisper db for graphite' :
    command     => '/opt/graphite/graphite/manage.py syncdb --noinput',
    creates     => '/opt/graphite/storage/graphite.db',
    environment => ['GRAPHITE_STORAGE_DIR=/opt/graphite/storage/','GRAPHITE_CONF_DIR=/opt/graphite/conf/']
  }

  file { '/etc/apache2/sites-available/graphite':
    ensure  => 'present',
    source  => 'puppet:///modules/graphite/apache.conf',
  }

  file { '/etc/apache2/sites-enabled/graphite':
    ensure  => link,
    target  => '/etc/apache2/sites-available/graphite',
    require => File['/etc/apache2/sites-available/graphite'],
  }

  file { '/etc/apache2/sites-enabled/000-default':
    ensure  => 'absent',
    require => File['/etc/apache2/sites-enabled/graphite'],
  }
}
