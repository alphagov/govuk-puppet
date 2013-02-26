class akamai_logs::log_scanner {

  $app_name = 'datainsight-akamai-scanner'

  file { "/data/vhost/${app_name}":
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy'
  }

  @logrotate::conf { "${app_name}-app":
    matches => "/data/vhost/${app_name}/shared/log/*.log",
  }
}
