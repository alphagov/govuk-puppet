class logster {
  file { '/usr/share/logster':
    ensure => directory,
    owner  => root,
    group  => root,
  }
  file { '/usr/share/logster/logster_helper.py':
    source  => 'puppet:///modules/logster/logster_helper.py',
    owner   => root,
    group   => root,
    require => File['/usr/share/logster'],
  }
  file { '/usr/share/logster/SampleGangliaLogster.py':
    source  => 'puppet:///modules/logster/SampleGangliaLogster.py',
    owner   => root,
    group   => root,
    require => File['/usr/share/logster'],
  }
  file { '/usr/share/logster/ApacheGangliaLogster.py':
    source  => 'puppet:///modules/logster/ApacheGangliaLogster.py',
    owner   => root,
    group   => root,
    require => File['/usr/share/logster'],
  }
  file { '/usr/share/logster/NginxGangliaLogster.py':
    source  => 'puppet:///modules/logster/NginxGangliaLogster.py',
    owner   => root,
    group   => root,
    require => File['/usr/share/logster'],
  }
  file { '/usr/sbin/logster':
    source => 'puppet:///modules/logster/logster',
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  Logster::Cronjob <| |>
}
