class graphite::config {
  file { '/var/log/graphite':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/etc/init/graphite.conf':
    source  => 'puppet:///modules/graphite/fastcgi_graphite.conf',
  }

  file { '/etc/init/carbon_cache.conf':
    source  => 'puppet:///modules/graphite/carbon_cache.conf',
  }

  file { '/opt/graphite/graphite/local-settings.py':
    source  => 'puppet:///modules/graphite/local_settings.py',
    require => [Package[python-graphite-web], Package[python-carbon]]
  }

  exec { 'create whisper db for graphite' :
    command => '/opt/graphite/graphite/manage.py syncdb --noinput'
  }

}