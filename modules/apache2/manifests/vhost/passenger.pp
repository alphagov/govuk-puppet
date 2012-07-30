define apache2::vhost::passenger($aliases = [], $environment='production', $additional_port=false) {
  include logster

  @@nagios::check { "check_apache_5xx_${name}_on_${::hostname}":
    check_command       => "check_ganglia_metric!${name}_apache_http_5xx!0.05!0.1",
    service_description => "check apache error rate for ${name}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  cron { "logster-apache-$name":
    command => "/usr/sbin/logster --metric-prefix $name ApacheGangliaLogster /var/log/apache2/${name}-access_log",
    user    => root,
    minute  => '*/2'
  }

  graylogtail::collect { "graylogtail-rails-$name":
    log_file => "/data/vhost/${name}/shared/log/production.log",
    facility => $name,
  }
  graylogtail::collect { "graylogtail-apache-access-$name":
    log_file => "/var/log/apache2/${name}-access_log",
    facility => $name,
  }
  graylogtail::collect { "graylogtail-apache-errors-$name":
    log_file => "/var/log/apache2/${name}-error_log",
    facility => $name,
    level    => 'error',
  }

  apache2::site { $name:
    content => template('apache2/passenger-vhost.conf'),
  }
}
