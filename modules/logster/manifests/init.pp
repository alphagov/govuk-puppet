class logster {
  file { '/usr/share/logster':
    ensure  => directory,
    owner   => root,
    group   => root,
    purge   => true,
    recurse => true,
    ignore  => '*.pyc',
    source  => 'puppet:///modules/logster/usr/share/logster',
  }
  file { '/usr/sbin/logster':
    source => 'puppet:///modules/logster/usr/sbin/logster',
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  Logster::Cronjob <| |>
}
