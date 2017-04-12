# == Define: govuk::app::config
#
# Configure a GOV.UK application
#
# === Parameters
#
# FIXME: Document all parameters
#
# [*nagios_memory_warning*]
#   Memory use, in MB, at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use, in MB, at which Nagios should generate a critical alert.
#
# [*proxy_http_version_1_1_enabled*]
#   Boolean, whether to enable HTTP/1.1 for proxying from the Nginx vhost
#   to the app server.
#
define govuk::app::config (
  $app_type,
  $domain,
  $port,
  $vhost_full,
  $command = 'NOTSET',
  $create_pidfile = 'NOTSET',
  $vhost_aliases = [],
  $vhost_protected = false,
  $vhost_ssl_only = false,
  $nginx_extra_config = '',
  $health_check_path = 'NOTSET',
  $expose_health_check = true,
  $json_health_check = false,
  $deny_framing = false,
  $enable_nginx_vhost = true,
  $unicorn_herder_timeout = 'NOTSET',
  $nagios_memory_warning = 700,
  $nagios_memory_critical = 800,
  $alert_5xx_warning_rate = 0.05,
  $alert_5xx_critical_rate = 0.1,
  $asset_pipeline = false,
  $asset_pipeline_prefix = 'assets',
  $ensure = 'present',
  $depends_on_nfs = false,
  $read_timeout = 15,
  $proxy_http_version_1_1_enabled = false,
) {
  $ensure_directory = $ensure ? {
    'present' => 'directory',
    'absent'  => 'absent',
  }
  $ensure_file = $ensure ? {
    'present' => 'file',
    'absent'  => 'absent',
  }

  # Check memory thresholds are approximately right
  validate_integer($nagios_memory_warning, 12000, 100)
  validate_integer($nagios_memory_critical, 14000, 200)

  # Use the International System of Units (SI) value of 1 million bytes in a MB
  # as it makes it simpler to evaluate memory usage when looking at our
  # metrics, which record memory usage in bytes
  $si_megabyte = 1000000
  $nagios_memory_warning_real = $nagios_memory_warning * $si_megabyte
  $nagios_memory_critical_real = $nagios_memory_critical * $si_megabyte

  # Ensure config dir exists
  file { "/etc/govuk/${title}":
    ensure  => $ensure_directory,
    purge   => true,
    recurse => true,
    force   => true,
    notify  => Govuk::App::Service[$title],
  }

  # Ensure env dir exists
  file { "/etc/govuk/${title}/env.d":
    ensure  => $ensure_directory,
    purge   => true,
    recurse => true,
    force   => true,
    notify  => Govuk::App::Service[$title],
  }

  unless $ensure == 'absent' {
    # This sets the default app and ensure for this resource type in the current scope
    Govuk::App::Envvar {
      app    => $title,
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
      govuk::app::envvar { "${title}-UNICORN_HERDER_TIMEOUT":
        varname => 'UNICORN_HERDER_TIMEOUT',
        value   => $unicorn_herder_timeout;
      }
    }

    if $app_type == 'procfile' and $create_pidfile {
      govuk::app::envvar { "${title}-GOVUK_MAKE_PIDFILE":
        varname => 'GOVUK_MAKE_PIDFILE',
        value   => '--make-pid';
      }
    }

    if $app_type == 'bare' and $command != 'NOTSET' {
      govuk::app::envvar { "${title}-GOVUK_APP_CMD":
        varname => 'GOVUK_APP_CMD',
        value   => $command,
      }
    }
  }

  # Used by the upstart config template
  $enable_service = hiera('govuk_app_enable_services', true)

  # Install service
  file { "/etc/init/${title}.conf":
    ensure  => $ensure_file,
    content => template('govuk/app_upstart.conf.erb'),
  }
  # The service instance won't exist when we're removing the app
  if $ensure_file != 'absent' {
    File["/etc/init/${title}.conf"] {
      notify => Service[$title],
    }
  }

  $vhost_aliases_real = regsubst($vhost_aliases, '$', ".${domain}")

  if $enable_nginx_vhost {

    if $expose_health_check {
      $hidden_paths = []
    } else {
      if $health_check_path == 'NOTSET' {
        fail('Cannot hide an unset health check path')
      }
      $hidden_paths = [$health_check_path]
    }

    # Expose this application from nginx
    govuk::app::nginx_vhost { $title:
      ensure                         => $ensure,
      vhost                          => $vhost_full,
      aliases                        => $vhost_aliases_real,
      protected                      => $vhost_protected,
      app_port                       => $port,
      ssl_only                       => $vhost_ssl_only,
      nginx_extra_config             => $nginx_extra_config,
      deny_framing                   => $deny_framing,
      asset_pipeline                 => $asset_pipeline,
      asset_pipeline_prefix          => $asset_pipeline_prefix,
      hidden_paths                   => $hidden_paths,
      read_timeout                   => $read_timeout,
      alert_5xx_warning_rate         => $alert_5xx_warning_rate,
      alert_5xx_critical_rate        => $alert_5xx_critical_rate,
      proxy_http_version_1_1_enabled => $proxy_http_version_1_1_enabled,
    }
  }
  $title_underscore = regsubst($title, '\.', '_', 'G')

  # Set up monitoring
  if $app_type in ['rack', 'bare'] {
    $collectd_process_regex = $app_type ? {
      'rack' => "unicorn (master|worker\\[[0-9]+\\]).* -P ${govuk_app_run}/app\\.pid",
      'bare' => inline_template('<%= "^" + Regexp.escape(@command) + "$" -%>'),
    }
    collectd::plugin::process { "app-${title_underscore}":
      ensure => $ensure,
      regex  => $collectd_process_regex,
    }
    @@icinga::check::graphite { "check_${title}_app_cpu_usage${::hostname}":
      ensure    => $ensure,
      target    => "scale(sumSeries(${::fqdn_metrics}.processes-app-${title_underscore}.ps_cputime.*),0.0001)",
      warning   => 150,
      critical  => 200,
      desc      => "high CPU usage for ${title} app",
      host_name => $::fqdn,
    }
    @@icinga::check::graphite { "check_${title}_app_mem_usage${::hostname}":
      ensure        => $ensure,
      target        => "${::fqdn_metrics}.processes-app-${title_underscore}.ps_rss",
      warning       => $nagios_memory_warning_real,
      critical      => $nagios_memory_critical_real,
      desc          => "high memory for ${title} app",
      host_name     => $::fqdn,
      event_handler => "govuk_app_high_memory!${title}",
    }
  }

  collectd::plugin::tcpconn { "app-${title_underscore}":
    ensure   => $ensure,
    incoming => $port,
    outgoing => $port,
  }

  @logrotate::conf { "govuk-${title}":
    ensure  => $ensure,
    matches => "/var/log/${title}/*.log",
  }

  @logrotate::conf { "govuk-${title}-rack":
    ensure  => $ensure,
    matches => "/data/vhost/${vhost_full}/shared/log/*.log",
    user    => 'deploy',
    group   => 'deploy',
  }

  if $health_check_path != 'NOTSET' {
    @@icinga::check { "check_app_${title}_up_on_${::hostname}":
      ensure              => $ensure,
      check_command       => "check_nrpe!check_app_up!${port} ${health_check_path}",
      service_description => "${title} app healthcheck",
      host_name           => $::fqdn,
    }
    if $json_health_check {
      include icinga::client::check_json_healthcheck

      $healthcheck_desc      = "${title} app health check not ok"
      $healthcheck_opsmanual = regsubst($healthcheck_desc, ' ', '-', 'G')

      @@icinga::check { "check_app_${title}_healthcheck_on_${::hostname}":
        ensure              => $ensure,
        check_command       => "check_nrpe!check_json_healthcheck!${port} ${health_check_path}",
        service_description => $healthcheck_desc,
        host_name           => $::fqdn,
        notes_url           => monitoring_docs_url($healthcheck_opsmanual),
      }
    }
  }
  if $app_type == 'rack' {
    @@icinga::check { "check_app_${title}_unicornherder_up_${::hostname}":
      ensure              => $ensure,
      check_command       => "check_nrpe!check_proc_running_with_arg!unicornherder /var/run/${title}/app.pid",
      service_description => "${title} app unicornherder not running",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(unicorn-herder),
    }
    include icinga::client::check_unicorn_workers
    @@icinga::check { "check_app_${title}_unicorn_workers_${::hostname}":
      ensure              => $ensure,
      check_command       => "check_nrpe!check_unicorn_workers!${title}",
      service_description => "${title} does not have the expected number of unicorn workers",
      host_name           => $::fqdn,
    }
    include icinga::client::check_unicorn_ruby_version
    @@icinga::check { "check_app_${title}_unicorn_ruby_version_${::hostname}":
      ensure              => $ensure,
      check_command       => "check_nrpe!check_unicorn_ruby_version!${title}",
      service_description => "${title} is not running the expected ruby version",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(ruby-version),
    }
  }
  @@icinga::check { "check_app_${title}_upstart_up_${::hostname}":
    ensure              => $ensure,
    check_command       => "check_nrpe!check_upstart_status!${title}",
    service_description => "${title} upstart not up",
    host_name           => $::fqdn,
  }
}
