class ganglia::nginx {
  file { '/var/www/ganglia-web-3.5.0/graph.d/nginx_scoreboard_report.php':
    source  => 'puppet:///modules/ganglia/graph.d/nginx_scoreboard_report.php',
    owner   => root,
    group   => root,
    require => Class['ganglia::config'],
  }
  file { '/var/www/ganglia-web-3.5.0/graph.d/nginx_accepts_ratio_report.php':
    source  => 'puppet:///modules/ganglia/graph.d/nginx_accepts_ratio_report.php',
    owner   => root,
    group   => root,
    require => Class['ganglia::config'],
  }
}
