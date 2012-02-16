class ganglia {
  include ganglia::install, ganglia::service, ganglia::web2
}

class ganglia::install {
  package {
    "ganglia-webfrontend": ensure => "installed";
  }
  file { "/etc/apache2/sites-enabled/ganglia":
    owner   => root,
    group   => root,
    ensure  => present,
    source => "puppet:///modules/ganglia/apache.conf",
    require => Package[ganglia-webfrontend],
  }
  file { "/etc/ganglia/gmetad.conf":
    source => "puppet:///modules/ganglia/gmetad.conf",
    owner => root,
    group => root,
    require => Package[ganglia-webfrontend],
  }

}

class ganglia::service {
  service { gmetad:
    ensure     => running,
    hasrestart => true,
    subscribe  => File["/etc/ganglia/gmetad.conf"],
    require    => Class["ganglia::install"],
  }
}

class ganglia::nginx {
  file { "/usr/share/ganglia-webfrontend/graph.d/nginx_scoreboard_report.php":
    source  => "puppet:///modules/ganglia/graph.d/nginx_scoreboard_report.php",
    owner   => root,
    group   => root,
    require => Class["ganglia::install"],
  }
  file { "/usr/share/ganglia-webfrontend/graph.d/nginx_accepts_ratio_report.php":
    source  => "puppet:///modules/ganglia/graph.d/nginx_accepts_ratio_report.php",
    owner   => root,
    group   => root,
    require => Class["ganglia::install"],
  }
}

class ganglia::client {
  include ganglia::client::install, ganglia::client::service
}

class ganglia::client::install {
  package {
    "ganglia-monitor": ensure => "installed";
  }
  file { "/etc/ganglia/gmond.conf":
    source  => "puppet:///modules/ganglia/gmond.conf",
    owner   => root,
    group   => root,
    require => Package[ganglia-monitor],
  }
}

class ganglia::client::service {
  service { ganglia-monitor:
    ensure     => running,
    hasrestart => true,
    hasstatus  => false,
    pattern    => "/usr/sbin/gmond",
    subscribe  => File["/etc/ganglia/gmond.conf"],
    require    => Class["ganglia::client::install"],
  }
}

class ganglia::web2 {
  file { "/var/www/ganglia2":
    ensure  => directory,
    recurse => true,
    purge   => false,
    force   => true,
    owner   => www-data,
    group   => www-data,
    source  => "puppet:///modules/ganglia/ganglia2",
    require => Class["ganglia::install"],
  }
  file { "/var/lib/ganglia/dwoo":
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
  }
  file { "/var/lib/ganglia/conf":
    ensure  => directory,
    owner   => www-data,
    group   => www-data,
  }
}
