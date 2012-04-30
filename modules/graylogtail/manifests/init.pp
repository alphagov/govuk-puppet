class graylogtail {
  file { '/usr/share/graylogtail':
    ensure => directory,
    owner  => root,
    group  => root,
  }
  file { '/usr/share/graylogtail/graypy':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/graylogtail/graypy',
    owner   => root,
    group   => root,
    require => File['/usr/share/graylogtail'],
  }
  file { '/usr/sbin/graylogtail':
    source => 'puppet:///modules/graylogtail/graylogtail',
    owner  => root,
    group  => root,
    mode   => '0755',
  }
}
