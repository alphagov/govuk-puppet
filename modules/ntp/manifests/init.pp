class ntp {

  package { "ntp":
    ensure => installed
  }

  service { "ntp":
    ensure => running,
    require => Package["ntp"]
  }

  file { "/etc/localtime":
    source => "/usr/share/zoneinfo/Etc/UTC"
  }

  file { "/etc/timezone":
    content => "Etc/UTC"
  }

}
