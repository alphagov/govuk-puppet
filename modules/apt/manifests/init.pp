class apt {

  file { '/etc/apt/sources.list':
    ensure => present,
    source => "puppet:///modules/apt/sources.list.${::lsbdistcodename}",
  }

  file { '/etc/apt/sources.list.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    ignore  => '*.save'
  }

  package { 'python-software-properties':
    ensure => installed,
    tag    => 'no_require_apt_update',
  }

  class { 'apt::update': }

  Class['apt::update'] -> Package <| provider != pip and provider != gem and ensure != absent and ensure != purged and tag != 'no_require_apt_update' |>

}
