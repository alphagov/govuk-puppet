class graylogtail {
  file { "/usr/share/graylogtail":
    ensure => directory,
    owner  => root,
    group  => root,
  }
  file { "/usr/share/graylogtail/graypy":
    ensure  => directory,
    recurse => true,
    source  => "puppet:///modules/graylogtail/graypy",
    owner   => root,
    group   => root,
    require => File["/usr/share/graylogtail"],
  }
  file { "/usr/sbin/graylogtail":
    source => "puppet:///modules/graylogtail/graylogtail",
    owner  => root,
    group  => root,
    mode   => 755,
  }

  define collect($log_file, $level = "info", $facility = "graylogtail", $host = "graylog.cluster") {
    $stripped_facility = facility_from_host($facility)
    cron { "cron-$name":
      command => "/usr/sbin/graylogtail $log_file --level $level --facility $stripped_facility --graylog-host $host",
      user => root,
      minute => '*/2'
    }
  }

}
