class apt {

  Exec['apt_update'] -> Package <| |>

  file { 'sources.list':
    ensure => present,
    name   => '/etc/apt/sources.list',
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  file { 'sources.list.d':
    ensure => directory,
    name   => '/etc/apt/sources.list.d',
    owner  => root,
    group  => root,
  }

  exec { 'apt_update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true
  }

  package { 'python-software-properties':
    ensure => installed,
  }

}
