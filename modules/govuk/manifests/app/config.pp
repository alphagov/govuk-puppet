define govuk::app::config (
  $app_type,
  $domain,
  $port,
  $vhost_full,
  $vhost_aliases = [],
  $vhost_protected = undef,
  $vhost_ssl_only = false,
  $nginx_extra_config = '',
  $nginx_extra_app_config = '',
  $health_check_path = 'NOTSET',
  $intercept_errors = false,
  $enable_nginx_vhost = true,
  $logstream = true,
  $nagios_cpu_warning = 150,
  $nagios_cpu_critical = 200,
  $unicorn_herder_timeout = 'NOTSET',
) {

  # Ensure config dir exists
  file { "/etc/govuk/${title}":
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    force   => true,
    notify  => Govuk::App::Service[$title],
  }

  # Ensure env dir exists
  file { "/etc/govuk/${title}/env.d":
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    force   => true,
    notify  => Govuk::App::Service[$title],
  }

  # This sets the default app for this resource type in the current scope
  Govuk::App::Envvar {
    app => $title
  }

  # Used more than once in this class.
  $govuk_app_run = "/var/run/${title}"

  govuk::app::envvar {
    "${title}-GOVUK_USER":
      varname => 'GOVUK_USER',
      value   => 'deploy';
    "${title}-GOVUK_GROUP":
      varname => 'GOVUK_GROUP',
      value   => 'deploy';
    "${title}-GOVUK_APP_TYPE":
      varname => 'GOVUK_APP_TYPE',
      value   => $app_type;
    "${title}-PORT":
      varname => 'PORT',
      value   => $port;
    "${title}-GOVUK_APP_NAME":
      varname => 'GOVUK_APP_NAME',
      value   => $title;
    "${title}-GOVUK_APP_ROOT":
      varname => 'GOVUK_APP_ROOT',
      value   => "/var/apps/${title}";
    "${title}-GOVUK_APP_RUN":
      varname => 'GOVUK_APP_RUN',
      value   => $govuk_app_run;
    "${title}-GOVUK_APP_LOGROOT":
      varname => 'GOVUK_APP_LOGROOT',
      value   => "/var/log/${title}";
    "${title}-GOVUK_STATSD_PREFIX":
      varname => 'GOVUK_STATSD_PREFIX',
      value   => "govuk.app.${title}.${::hostname}";
  }

  if $app_type == 'rack' and $unicorn_herder_timeout != 'NOTSET' {
    govuk::app::envvar {
      "${title}-UNICORN_HERDER_TIMEOUT":
        varname => 'UNICORN_HERDER_TIMEOUT',
        value   => $unicorn_herder_timeout;
    }
  }

  # Used by the upstart config template
  $enable_service = str2bool(extlookup('govuk_app_enable_services', 'yes'))

  # Install service
  file { "/etc/init/${title}.conf":
    content => template('govuk/app_upstart.conf.erb'),
    notify  => Service[$title],
  }

  $vhost_aliases_real = regsubst($vhost_aliases, '$', ".${domain}")

  if $enable_nginx_vhost {
    # Expose this application from nginx
    govuk::app::nginx_vhost { $title:
      vhost                  => $vhost_full,
      aliases                => $vhost_aliases_real,
      protected              => $vhost_protected,
      app_port               => $port,
      ssl_only               => $vhost_ssl_only,
      nginx_extra_config     => $nginx_extra_config,
      nginx_extra_app_config => $nginx_extra_app_config,
      intercept_errors       => $intercept_errors,
      logstream              => $logstream,
    }
  }
  $title_underscore = regsubst($title, '\.', '_', 'G')

  # Set up monitoring
  collectd::plugin::process { "app-${title_underscore}":
    regex => "unicorn (master|worker\\[[0-9]+\\]).* -P ${govuk_app_run}/app\\.pid",
  }

  collectd::plugin::tcpconn { "app-${title_underscore}":
    incoming => $port,
    outgoing => $port,
  }

  @logrotate::conf { "govuk-${title}":
    matches => "/var/log/${title}/*.log",
  }

  @logrotate::conf { "govuk-${title}-rack":
    matches => "/data/vhost/${vhost_full}/shared/log/*.log",
  }

  @@nagios::check::graphite { "check_${title}_app_cpu_usage${::hostname}":
    target    => "scale(sumSeries(${::fqdn_underscore}.processes-app-${title_underscore}.ps_cputime.*),0.0001)",
    warning   => $nagios_cpu_warning,
    critical  => $nagios_cpu_critical,
    desc      => "high CPU usage for ${title} app",
    host_name => $::fqdn,
  }
  @@nagios::check::graphite { "check_${title}_app_mem_usage${::hostname}":
    target    => "${::fqdn_underscore}.processes-app-${title_underscore}.ps_rss",
    warning   => 2000000000,
    critical  => 3000000000,
    desc      => "high memory for ${title} app",
    host_name => $::fqdn,
  }
  if $health_check_path != 'NOTSET' {
    @@nagios::check { "check_app_${title}_up_on_${::hostname}":
      check_command       => "check_nrpe!check_app_up!${port} ${health_check_path}",
      service_description => "${title} app running",
      host_name           => $::fqdn,
    }
  }
  @@nagios::check { "check_app_${title}_unicornherder_up_${::hostname}":
    check_command       => "check_nrpe!check_proc_running_with_arg!unicornherder /var/run/${title}/app.pid",
    service_description => "${title} app unicornherder running",
    host_name           => $::fqdn,
    document_url        => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#app-unicornherder-running',
  }
}
