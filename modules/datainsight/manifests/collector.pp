define datainsight::collector ($platform = $::govuk_platform) {

  # Variable setup
  $vhost = "datainsight-${title}-collector"

  $domain = $platform ? {
    'development' => 'dev.gov.uk',
    default       => "${platform}.alphagov.co.uk",
  }

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
