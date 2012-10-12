define govuk::app::config (
  $app_type,
  $domain,
  $port,
  $vhost_full,
  $vhost_aliases = [],
  $vhost_protected = true,
  $vhost_ssl_only = false,
  $nginx_extra_config = '',
  $nginx_extra_app_config = '',
  $platform = $::govuk_platform,
  $health_check_path = 'NOTSET',
  $environ_source  = undef,
  $environ_content = undef,
  $enable_nginx_vhost = true
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

  if $health_check_path == 'NOTSET' {
    $health_check_port = 'NOTSET'
    $ssl_health_check_port = 'NOTSET'
  }
  else {
    $health_check_port = $port + 6500
    $ssl_health_check_port = $port + 6400
    @ufw::allow {
      "allow-loadbalancer-health-check-${title}-http-from-all":
        port => $health_check_port;
      "allow-loadbalancer-health-check-${title}-https-from-all":
        port => $ssl_health_check_port;
    }
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

  if $enable_nginx_vhost {
    # Expose this application from nginx
    nginx::config::vhost::proxy { $vhost_full:
      to                    => ["localhost:${port}"],
      aliases               => $vhost_aliases_real,
      protected             => $vhost_protected,
      ssl_only              => $vhost_ssl_only,
      extra_config          => $nginx_extra_config,
      extra_app_config      => $nginx_extra_app_config,
      platform              => $platform,
      health_check_path     => $health_check_path,
      health_check_port     => $health_check_port,
      ssl_health_check_port => $ssl_health_check_port,
    }
  }

  # Set up monitoring
  @ganglia::pymod_alias { "app-${title}-procstat":
    target => "procstat",
  }

  @ganglia::pyconf { "app-${title}":
    content => template('govuk/etc/ganglia/conf.d/procstat.pyconf.erb'),
    require => File["/usr/lib/ganglia/python_modules/app-${title}-procstat.py"]
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
    service_description => "high CPU usage for ${title} app",
    host_name           => "${::govuk_class}-${::hostname}",
  }
  @@nagios::check { "check_${title}_app_mem_usage${::hostname}":
    check_command       => "check_ganglia_metric!procstat_${title}_mem!1000000000!2000000000",
    service_description => "high memory for ${title} app",
    host_name           => "${::govuk_class}-${::hostname}",
  }
  if $health_check_path != 'NOTSET' {
    @@nagios::check { "check_app_${title}_up_on_${::hostname}":
      check_command       => "check_nrpe!check_app_up!${port} ${health_check_path}",
      service_description => "${title} app running on ${::govuk_class}-${::hostname}",
      host_name           => "${::govuk_class}-${::hostname}",
    }
  }
}
