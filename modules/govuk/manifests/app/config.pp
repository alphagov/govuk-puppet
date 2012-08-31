define govuk::app::config (
  $app_type,
  $domain,
  $port,
  $vhost_aliases,
  $vhost_full,
  $vhost_protected,
  $vhost_ssl_only,
  $nginx_extra_config,
  $platform,
  $health_check_path,
  $health_check_port,
  $environ_source  = undef,
  $environ_content = undef
) {
  if $environ_content != undef and $environ_source != undef {
    fail 'You may only set one of $environ_content and $environ_source in govuk::app'
  }

  if $environ_source == undef and $environ_content == undef {
    $environ_content_real = ''
  }
  else {
    $environ_content_real = $environ_content
  }

  # Install environment/configuration file
  file { "/etc/envmgr/${title}.conf":
    ensure  => 'file',
    source  => $environ_source,
    content => $environ_content_real,
  }

  # Install service
  file { "/etc/init/${title}.conf":
    content => template('govuk/app_upstart.conf.erb');
  }

  $vhost_aliases_real = regsubst($vhost_aliases, '$', ".${domain}")

  # Expose this application from nginx
  nginx::config::vhost::proxy { $vhost_full:
    to                => ["localhost:${port}"],
    aliases           => $vhost_aliases_real,
    protected         => $vhost_protected,
    ssl_only          => $vhost_ssl_only,
    extra_config      => $nginx_extra_config,
    platform          => $platform,
    health_check_path => $health_check_path,
    health_check_port => $health_check_port
  }

  # Set up monitoring
  if $platform != 'development' {
    file { "/usr/lib/ganglia/python_modules/app-${title}-procstat.py":
      ensure  => link,
      target  => '/usr/lib/ganglia/python_modules/procstat.py',
      require => Ganglia::Pymod['procstat'],
    }
  }

  @ganglia::pyconf { "app-${title}":
    content => template('govuk/etc/ganglia/conf.d/procstat.pyconf.erb'),
    require => File["/usr/lib/ganglia/python_modules/app-${title}-procstat.py"],
  }

  @logstash::collector { "app-${title}":
    content => template('govuk/app_logstash.conf.erb'),
  }

  @logrotate::conf { "govuk-${title}":
    matches => "/var/log/${title}/*.log",
  }

  @logrotate::conf { "govuk-${title}-rack":
    matches => "/data/vhost/${vhost_full}/shared/log/*.log",
  }

  @@nagios::check { "check_${title}_app_cpu_usage${::hostname}":
    check_command       => "check_ganglia_metric!procstat_${title}_cpu!50!100",
    service_description => "Check CPU used by app ${title} is not too high",
    host_name           => "${::govuk_class}-${::hostname}",
  }
  @@nagios::check { "check_${title}_app_mem_usage${::hostname}":
    check_command       => "check_ganglia_metric!procstat_${title}_mem!1000000000!2000000000",
    service_description => "Check memory used by app ${title} is not too high",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
