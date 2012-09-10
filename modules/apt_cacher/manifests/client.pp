class apt_cacher::client {
  file {'/etc/apt/apt.conf.d/01proxy':
    ensure  => absent,
    content => 'Acquire::http { Proxy "http://support.cluster:3142"; };'
  }
}
