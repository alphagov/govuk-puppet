# == Define: govuk::app::config
#
# Configure a GOV.UK application
#
# === Parameters
#
# FIXME: Document all parameters
#
# [*health_check_service_template*]
#   The title of a `Icinga::Service_template` from which the
#   healthcheck check should inherit.
#
# [*health_check_notification_period*]
#   The title of a `Icinga::Timeperiod` resource to be used by the
#   healthcheck.
#
# [*additional_check_contact_groups*]
#   Additional contact groups to pass to the icinga::checks for this
#   application.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*nagios_memory_warning*]
#   Memory use, in MB, at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use, in MB, at which Nagios should generate a critical alert.
#
# [*alert_notification_period*]
#   The notification period of the alert, passed to govuk::app::nginx_vhost.
#
# [*proxy_http_version_1_1_enabled*]
#   Boolean, whether to enable HTTP/1.1 for proxying from the Nginx vhost
#   to the app server.
#
# [*unicorn_worker_processes*]
#   The number of unicorn worker processes to run, set as an env var
#   and read by govuk_app_config.  The default value of undef means
#   don't set the env var, and use on govuk_app_config's default value.
#   Default: undef
#
# [*cpu_warning*]
#   CPU usage percentage that alerts are sounded at
#   Default: undef
#
# [*cpu_critical*]
#   CPU usage percentage that alerts are sounded at
#
# [*collectd_process_regex*]
#   Regex to use to identify the process.
#
# [*override_search_location*]
#   Alternative hostname to use for Plek("search") and Plek("rummager")
#
# [*create_default_nginx_config*]
#   Create the default.conf site in nginx
#   Default: false
#
# [*monitor_unicornherder*]
#   Whether to set up Icinga alerts that monitor unicornherder. This is true if
#   the app_type is set to 'rack' but this is useful if your app uses a Procfile
#   which runs unicornherder.
#   Default: true if app_type is 'rack' else false
#
# [*local_tcpconns_established_warning*]
#   Warning value to use for the Icinga check on the number of
#   established TCP connections to $port.
#   Default: undef
#
# [*local_tcpconns_established_critical*]
#   Critical value to use for the Icinga check on the number of
#   established TCP connections to $port.
#   Default: undef
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
  $health_check_service_template = 'govuk_regular_service',
  $health_check_notification_period = undef,
  $additional_check_contact_groups = undef,
  $deny_framing = false,
  $enable_nginx_vhost = true,
  $unicorn_herder_timeout = 'NOTSET',
  $nagios_memory_warning = 700,
  $nagios_memory_critical = 800,
  $alert_5xx_warning_rate = 0.05,
  $alert_5xx_critical_rate = 0.1,
  $alert_notification_period = undef,
  $asset_pipeline = false,
  $asset_pipeline_prefix = 'assets',
  $ensure = 'present',
  $depends_on_nfs = false,
  $read_timeout = 15,
  $proxy_http_version_1_1_enabled = false,
  $sentry_dsn = undef,
  $unicorn_worker_processes = undef,
  $cpu_warning = 150,
  $cpu_critical = 200,
  $collectd_process_regex = undef,
  $alert_when_threads_exceed = undef,
  $override_search_location = undef,
  $create_default_nginx_config = false,
  $monitor_unicornherder = undef,
  $local_tcpconns_established_warning = undef,
  $local_tcpconns_established_critical = undef,
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
        value   => "${port}"; # lint:ignore:only_variable_string
      "${title}-GOVUK_APP_NAME":
        varname => 'GOVUK_APP_NAME',
        value   => $title;
      "${title}-GOVUK_APP_ROOT":
        varname => 'GOVUK_APP_ROOT',
        value   => "/var/apps/${title}";
      "${title}-GOVUK_APP_RUN":
        varname => 'GOVUK_APP_RUN',
        value   => $govuk_app_run;
      "${title}-GOVUK_STATSD_PREFIX":
        varname => 'GOVUK_STATSD_PREFIX',
        value   => "govuk.app.${title}.${::hostname}";
      "${title}-SENTRY_DSN":
        varname => 'SENTRY_DSN',
        value   => $sentry_dsn;
    }

    if $override_search_location {
      govuk::app::envvar {
        "${title}-PLEK_SERVICE_SEARCH_URI":
          varname => 'PLEK_SERVICE_SEARCH_URI',
          value   => $override_search_location;
        "${title}-PLEK_SERVICE_RUMMAGER_URI":
          varname => 'PLEK_SERVICE_RUMMAGER_URI',
          value   => $override_search_location;
      }
    }

    if 'development' != $::govuk_node_class {
      govuk::app::envvar { "${title}-GOVUK_APP_LOGROOT":
        varname => 'GOVUK_APP_LOGROOT',
        value   => "/var/log/${title}",
      }
    }

    if $app_type == 'rack' and $unicorn_herder_timeout != 'NOTSET' {
      govuk::app::envvar { "${title}-UNICORN_HERDER_TIMEOUT":
        varname => 'UNICORN_HERDER_TIMEOUT',
        value   => "${unicorn_herder_timeout}"; # lint:ignore:only_variable_string
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

    if $unicorn_worker_processes {
      govuk::app::envvar { "${title}-UNICORN_WORKER_PROCESSES":
        varname => 'UNICORN_WORKER_PROCESSES',
        value   => "${unicorn_worker_processes}"; # lint:ignore:only_variable_string
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

  if $::aws_migration {
    $vhost_aliases_real = $vhost_aliases
  } else {
    $vhost_aliases_real = regsubst($vhost_aliases, '$', ".${domain}")
  }

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
      alert_notification_period      => $alert_notification_period,
      proxy_http_version_1_1_enabled => $proxy_http_version_1_1_enabled,
    }

    if ($create_default_nginx_config == true) and ($::aws_environment == 'staging' or $::aws_environment == 'production') {
      nginx::config::vhost::app_default { 'default':
        app_healthcheck_url     => $health_check_path,
        app_hostname            => $title,
        app_port                => $port,
        default_healthcheck_url => '/_healthcheck',
      }
    }

    if defined(Concat['/etc/nginx/lb_healthchecks.conf']) and $health_check_path != 'NOTSET' {
      concat::fragment { "${title}_lb_healthcheck":
        target  => '/etc/nginx/lb_healthchecks.conf',
        content => "location /_healthcheck_${vhost_full} {\n  proxy_pass http://${vhost_full}-proxy${health_check_path};\n}\n",
      }
    }
  }
  $title_underscore = regsubst($title, '\.', '_', 'G')

  # Set up monitoring
  if $app_type in ['rack', 'bare', 'procfile'] {
    $default_collectd_process_regex = $app_type ? {
      'rack' => "unicorn (master|worker\\[[0-9]+\\]).* -P ${govuk_app_run}/app\\.pid",
      'bare' => inline_template('<%= Regexp.escape(@command) + "$" -%>'),
      'procfile' => "gunicorn .* ${govuk_app_run}/app\\.pid",
    }

    collectd::plugin::process { "app-${title_underscore}":
      ensure => $ensure,
      regex  => pick($collectd_process_regex, $default_collectd_process_regex),
    }
    @@icinga::check::graphite { "check_${title_underscore}_app_process_count_${::hostname}":
      ensure    => $ensure,
      target    => "${::fqdn_metrics}.processes-app-${title_underscore}.ps_count.processes",
      warning   => '@0', # WARN if there are 0 processes
      critical  => '@-1', # Don't use the CRITICAL status for now
      desc      => "No processes found for ${title_underscore}",
      host_name => $::fqdn,
      from      => '30seconds',
    }
    @@icinga::check::graphite { "check_${title}_app_cpu_usage${::hostname}":
      ensure         => $ensure,
      target         => "scale(sumSeries(${::fqdn_metrics}.processes-app-${title_underscore}.ps_cputime.*),0.0001)",
      warning        => $cpu_warning,
      critical       => $cpu_critical,
      desc           => "high CPU usage for ${title} app",
      host_name      => $::fqdn,
      contact_groups => $additional_check_contact_groups,
    }
    @@icinga::check::graphite { "check_${title}_app_mem_usage${::hostname}":
      ensure                     => $ensure,
      target                     => "${::fqdn_metrics}.processes-app-${title_underscore}.ps_rss",
      warning                    => $nagios_memory_warning_real,
      critical                   => $nagios_memory_critical_real,
      desc                       => "high memory for ${title} app",
      host_name                  => $::fqdn,
      event_handler              => "govuk_app_high_memory!${title}",
      notes_url                  => monitoring_docs_url(high-memory-for-application),
      attempts_before_hard_state => 2,
      contact_groups             => $additional_check_contact_groups,
    }
    @@icinga::check::graphite { "check_${title}_app_memory_restarts${::hostname}":
      ensure         => $ensure,
      target         => "summarize(transformNull(stats_counts.govuk.app.${title}.memory_restarts,0),\"1d\",\"sum\",false)",
      args           => '--ignore-missing',
      from           => '2days',
      warning        => 4,
      critical       => 10 ,
      desc           => 'Restarts per day due to excessive memory usage',
      host_name      => $::fqdn,
      contact_groups => $additional_check_contact_groups,
    }
    if $alert_when_threads_exceed {
      @@icinga::check::graphite { "check_${title}_app_thread_count_${::hostname}":
        ensure         => $ensure,
        target         => "${::fqdn_metrics}.processes-app-${title_underscore}.ps_count.threads",
        warning        => $alert_when_threads_exceed,
        critical       => $alert_when_threads_exceed,
        desc           => "Thread count for ${title_underscore} exceeds ${alert_when_threads_exceed}",
        host_name      => $::fqdn,
        contact_groups => $additional_check_contact_groups,
      }
    }
  }

  if $port != 0 {
    collectd::plugin::tcpconn { "app-${title_underscore}":
      ensure   => $ensure,
      incoming => $port,
      outgoing => $port,
    }

    $local_tcpconns_warning = pick(
      $local_tcpconns_established_warning,
      $unicorn_worker_processes,
      2 # Defualt from govuk_app_config for Unicorn worker processes
    )
    $local_tcpconns_critical = pick(
      $local_tcpconns_established_critical,
      $local_tcpconns_warning + 2
    )

    @@icinga::check::graphite { "check_${title}_app_local_tcpconns_${::hostname}":
      ensure         => $ensure,
      target         => "${::fqdn_metrics}.tcpconns-${port}-local.tcp_connections-ESTABLISHED",
      warning        => $local_tcpconns_warning,
      critical       => $local_tcpconns_critical,
      desc           => "Established connections for ${title_underscore} exceeds ${local_tcpconns_warning}",
      host_name      => $::fqdn,
      notes_url      => monitoring_docs_url(established-connections-exceed),
      contact_groups => $additional_check_contact_groups,
    }
  }

  @logrotate::conf { "govuk-${title}":
    ensure  => $ensure,
    matches => "/var/log/${title}/*.log",
    maxsize => '100M',
  }

  @logrotate::conf { "govuk-${title}-rack":
    ensure  => $ensure,
    matches => "/data/vhost/${vhost_full}/shared/log/*.log",
    user    => 'deploy',
    group   => 'deploy',
    maxsize => '100M',
  }

  if $health_check_path != 'NOTSET' {
    @@icinga::check { "check_app_${title}_up_on_${::hostname}":
      ensure              => $ensure,
      check_command       => "check_app_health!check_app_up!${port} ${health_check_path}",
      service_description => "${title} app healthcheck",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(app-healthcheck-failed),
      contact_groups      => $additional_check_contact_groups,
    }
    if $json_health_check {
      include icinga::client::check_json_healthcheck

      $healthcheck_desc      = "${title} app healthcheck not ok"
      $healthcheck_opsmanual = regsubst($healthcheck_desc, ' ', '-', 'G')

      @@icinga::check { "check_app_${title}_healthcheck_on_${::hostname}":
        ensure              => $ensure,
        check_command       => "check_app_health!check_json_healthcheck!${port} ${health_check_path}",
        service_description => $healthcheck_desc,
        use                 => $health_check_service_template,
        notification_period => $health_check_notification_period,
        host_name           => $::fqdn,
        notes_url           => monitoring_docs_url($healthcheck_opsmanual),
        contact_groups      => $additional_check_contact_groups,
      }
    }
  }
  if ($app_type == 'rack') or $monitor_unicornherder {
    @@icinga::check { "check_app_${title}_unicornherder_up_${::hostname}":
      ensure              => $ensure,
      check_command       => "check_nrpe!check_proc_running_with_arg!unicornherder /var/run/${title}/app.pid",
      service_description => "${title} app unicornherder not running",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(unicorn-herder),
      contact_groups      => $additional_check_contact_groups,
    }
  }
  if $app_type == 'rack' {
    include icinga::client::check_unicorn_workers
    @@icinga::check { "check_app_${title}_unicorn_workers_${::hostname}":
      ensure              => $ensure,
      check_command       => "check_nrpe!check_unicorn_workers!${title}",
      service_description => "${title} does not have the expected number of unicorn workers",
      host_name           => $::fqdn,
      contact_groups      => $additional_check_contact_groups,
    }
    include icinga::client::check_unicorn_ruby_version
    @@icinga::check { "check_app_${title}_unicorn_ruby_version_${::hostname}":
      ensure              => $ensure,
      check_command       => "check_nrpe!check_unicorn_ruby_version!${title}",
      service_description => "${title} is not running the expected ruby version",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(ruby-version),
      contact_groups      => $additional_check_contact_groups,
    }
  }
  @@icinga::check { "check_app_${title}_upstart_up_${::hostname}":
    ensure              => $ensure,
    check_command       => "check_nrpe!check_upstart_status!${title}",
    service_description => "${title} upstart not up",
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
    contact_groups      => $additional_check_contact_groups,
  }
}
