class graphite::service {
  file { '/etc/init/carbon_cache.conf':
    source  => 'puppet:///modules/graphite/carbon_cache.conf',
    require =>  Package[python-carbon],
  }

  service { 'carbon_cache':
    ensure    => running,
    provider  => upstart,
    subscribe => File['/etc/init/carbon_cache.conf'],
    require   => [File['/etc/init/carbon_cache.conf'], File['/opt/graphite/conf/carbon.conf']],
  }

  file { '/etc/init/graphite.conf':
    source => 'puppet:///modules/graphite/fastcgi_graphite.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  service { 'graphite':
    ensure    => running,
    require   => [File['/etc/init/graphite.conf'], File['/opt/graphite/conf/storage-schemas.conf']],
    provider  => upstart,
  }

}
