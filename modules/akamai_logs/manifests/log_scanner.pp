class akamai_logs::log_scanner {

  $app_name = 'datainsight-akamai-scanner'

  user { 'deploy':
    ensure      => present,
    group       => 'deploy'
  }

  file { "/data/vhost/${app_name}":
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy'
  }

  @logstash::collector { "app-${app_name}":
    content => template("datainsight/log_scanner_logstash.conf.erb"),
  }

  @logrotate::conf { "${app_name}-app":
    matches => "/data/vhost/${app_name}/shared/log/*.log",
  }
}