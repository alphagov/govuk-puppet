class mapit {
  mapit::get_data{'get_recent_data':
    mapit_datadir => '/data/vhosts/mapit',
  }
  package{['python-yaml','memcached','python-memcache','git-core']:
    ensure => present,
  }
}
