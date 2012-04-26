class ganglia::nginx {
  file { '/usr/share/ganglia-webfrontend/graph.d/nginx_scoreboard_report.php':
    source  => 'puppet:///modules/ganglia/graph.d/nginx_scoreboard_report.php',
    owner   => root,
    group   => root,
    require => Class['ganglia::install'],
  }
  file { '/usr/share/ganglia-webfrontend/graph.d/nginx_accepts_ratio_report.php':
    source  => 'puppet:///modules/ganglia/graph.d/nginx_accepts_ratio_report.php',
    owner   => root,
    group   => root,
    require => Class['ganglia::install'],
  }
}
