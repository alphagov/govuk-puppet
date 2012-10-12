define apache2::vhost::passenger($aliases = [], $environment='production', $additional_port=false) {

  @logster::cronjob { "apache2-vhost-${name}":
    args => "--metric-prefix ${title} ApacheGangliaLogster /var/log/apache2/${name}-access.log",
  }

  @@nagios::check { "check_apache_5xx_${name}_on_${::hostname}":
    check_command       => "check_ganglia_metric!${name}_apache_http_5xx!0.05!0.1",
    service_description => "apache 5xx rate for ${name}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  apache2::site { $name:
    content => template('apache2/passenger-vhost.conf'),
  }

}
