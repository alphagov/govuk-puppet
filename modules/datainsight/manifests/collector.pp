define datainsight::collector {

  # Variable setup
  $domain = extlookup('app_domain')
  $vhost = "datainsight-${title}-collector"
  $vhost_full = "${vhost}.${domain}"

  include datainsight::config::google_oauth

  file { "/data/vhost/${vhost_full}":
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy';
  }

  @logstash::collector { "app-${vhost}":
    content => template("datainsight/collector_logstash.conf.erb"),
  }

  @logrotate::conf { "${vhost}-app":
    matches => "/data/vhost/${vhost_full}/shared/log/*.log",
  }
}
