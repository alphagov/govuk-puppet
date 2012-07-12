class graphite::config {
  file { '/var/log/graphite':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/etc/init/carbon_cache.conf':
    source  => 'puppet:///modules/graphite/carbon_cache.conf',
    require =>  Package[python-carbon],
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
    ensure  => 'directory'
    require => File['/opt/graphite/storage']
  }

  exec { 'create whisper db for graphite' :
    command     => '/opt/graphite/graphite/manage.py syncdb --noinput',
    require     => [Package[python-whisper],File['/opt/graphite/graphite/manage.py']],
    creates     => '/opt/graphite/storage/graphite.db',
    environment => ['GRAPHITE_STORAGE_DIR=/opt/graphite/storage/','GRAPHITE_CONF_DIR=/opt/graphite/conf/']
  }

}
