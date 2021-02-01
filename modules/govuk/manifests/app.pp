# == Define: govuk::app
#
# Configure an app server to run this app. Sets up everything necessary
# including Nginx, log collection, upstart jobs, environment variables etc.
#
# === Parameters
#
# [*app_type*] 'rack', 'procfile', or 'bare'.
#
# An app_type of 'rack' will assume the presence of a `config.ru` file in
# the root of the deployed application, and will run the rack up under
# unicorn.
#
# An app_type of 'procfile' will assume the presence of a `Procfile` in the
# root of the deployed application, which defines a 'web' process type.
#
# An app_type of 'bare' will use the string passed to the `command`
# parameter to start the application. For cases where a `Procfile` is
# unnecessary.
#
#
# [*port*]
# internal HTTP port for the application.
#
# If the `app_type` is rack, the -P option will be passed to unicorn
# automatically. If the `app_type` is 'procfile', then the command run by
# the Procfile MUST listen on the port defined by the 'PORT' environment
# variable.
#
# Optional, if the `app_type` is 'bare'.
#
#
# [*command*]
# command to start the application
#
# Used when `app_type` is 'bare'. This will be passed to a variable called
# `GOVUK_APP_CMD` which is used by `govuk_spinup`.
#
#
# [*create-pidfile*]
# Determines whether a pidfile is created when a `procfile` app is started
#
# By default procfile apps will create pid files (via the --make-pid switch
# in govuk_spinup).
# If the create-pidfile value is set to false, then a pid file will not be
# created.  This is appropriate when using unicornherder with gunicorn.
# The value defaults to 'NOTSET' (as opposed to true) to try to flag up that
# this doesn't apply to all app types. (eg Rack apps don't create pid files
# by default)
#
# [*log_format_is_json*]
# Whether the legacy application logs are in JSON format. If set to true,
# logstream will consume this as a logstash JSON event formatted stream.
#
# Default: false
#
# [*health_check_path*]
# path at which to check the status of the application.
#
# This is used to export health checks to ensure the application is running
# correctly.
#
# [*health_check_custom_doc*]
#   By default the alert doc will be "app-healthcheck-not-ok".
#   Set to true to change this to "<app>-app-healthcheck-not-ok".
#
# [*json_health_check*]
# whether the app's health check is exposed as JSON.
#
# Some of our apps are adopting a JSON-based healthcheck convention, where
# there is an overall `status` field that summarises the health of the app,
# and a `checks` dictionary with the results of individual app-level checks.
# Setting this to true will add a monitoring check that the healthcheck
# reports the app's status as OK.
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
# [*check_period*]
#   The title of a `Icinga::Timeperiod` resource describing when Icinga
#   checks relating to this app should run.
#
# [*deny_framing*]
# should we allow this app to be framed
#
# If set to true, the nginx fronting the app will set the X-Frame-Options
# header in such a way as to deny framing in clients that support the header.
#
#
# [*enable_nginx_vhost*]
# should this app be fronted by nginx?
#
# Boolean: true or false
#
#
# [*vhost*]
# the virtual host prefix for this app
#
# Defaults to $title, the name of your application.
#
# The app will be served at "$vhost.$app_domain".
#
#
# [*vhost_aliases*]
# other vhosts on which your app is served
#
# Use of this parameter is discouraged: there should preferably be one and
# only one home for your application. Moreover, all apps are served from a
# common namespace, and the more names an app has, the greater the chances
# of a namespace collision.
#
#
# [*vhost_protected*]
# should this vhost be protected with HTTP Basic auth?
#
# Boolean: true or false
#
# Default: false
#
#
# [*vhost_ssl_only*]
# should this app be served exclusively over HTTPS
#
# Boolean: true or false
#
#
# [*nginx_extra_config*]
# additional nginx configuration for this app
#
# This parameter can be used to supply additional nginx configuration
# directives to be included in your application. In general, use of this
# parameter indicates that your app is doing something "special", and we
# should be striving for an infrastructure that contains the smallest
# possible number of "special cases". As such, use of this option is
# discouraged, and it is included for backwards compatibility purposes only.
#
# [*nginx_cache*]
# configuration to enable caching within ngnix
#
# This parameter can be used to set up a nginx cache and takes a hash with
# values for the following keys: `key_name`, `key_size`, `max_age` and
# `max_size`. Use of this option is discouraged.
#
# Default: {}
#
# [*nagios_memory_warning*]
# memory use at which Nagios should generate a warning
#
# This parameter is used to change the threshold of the exported nagios
# memory check. It defaults to 2GB for a warning and does not generally
# need to be altered. Default is `undef` so we can explicitly pass `undef`
# to use the default value.
#
#
# [*nagios_memory_critical*]
# memory use at which Nagios should generate a critical
#
# This parameter is used to change the threshold of the exported nagios
# memory check. It defaults to 3GB for a critical and does not generally
# need to be altered. Default is `undef` so we can explicitly pass `undef`
# to use the default value.
#
# [*alert_5xx_warning_rate*]
# the 5xx error percentage that should generate a warning
#
# [*alert_5xx_critical_rate*]
# the 5xx error percentage that should generate a critical
#
# [*unicorn_herder_timeout*]
# the timeout (in seconds) period to wait for
#
# Provides a way to override the default wait period for the 'failed to
# daemonize' error that occurs if an application doesn't load within
# the timeout period.
#
# [*asset_pipeline*]
# should we enable some asset pipeline specific rules in the
# nginx config. Set this value to true to create assets when the app is deployed.
#
#
# [*asset_pipeline_prefixes*]
# the path prefixes from which assets are served.  This should
# match the application's config.assets.prefix (which defaults to 'assets').
# This is an array that can accept multiple items to allow tranisitioning
# assets locations.
#
# [*ensure*]
# allow govuk app to be removed.
#
# [*hasrestart*]
# specify if the app init script has a restart command
# Default: false
#
# [*depends_on_nfs*]
# Start the application after mounted filesystems. Some applications
# depend on NFS shares for functionality. They should not start until the mounted
# filesystem has been connected. The default for this is false.
#
#
# [*read_timeout*]
# Configure the amount of time the nginx proxy vhost will wait for the
# backing app before it sends the client a 504. It defaults to 15 seconds.
#
# [*proxy_http_version_1_1_enabled*]
#   Boolean, whether to enable HTTP/1.1 for proxying from the Nginx vhost
#   to the app server.
#
#
# [*repo_name*]
# the name of the repository that contains this app, if it is different from
# $title
#
# This parameter is used to ensure symlinks are created correctly if the app
# name and repo name don't match
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
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
# [*alert_when_threads_exceed*]
#   If set, alert using Icinga if the number of threads exceeds the value specified.
#   Default: 100
#
# [*alert_when_file_handles_exceed*]
#   If set, alert using Icinga if the number of file handles exceeds
#   the value specified.
#   Default: 500
#
# [*override_search_location*]
#   Alternative hostname to use for Plek("search") and Plek("rummager")
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
# [*ensure_service*]
#   The ensure value passed to the service. You can use this to configure the
#   app but stop the service from running.
#   Default: running
#
define govuk::app (
  $app_type,
  $port = 0,
  $command = undef,
  $create_pidfile = 'NOTSET',
  $log_format_is_json = false,
  $health_check_path = 'NOTSET',
  $health_check_custom_doc = undef,
  $json_health_check = false,
  $health_check_service_template = 'govuk_regular_service',
  $health_check_notification_period = undef,
  $additional_check_contact_groups = undef,
  $check_period = undef,
  $deny_framing = false,
  $enable_nginx_vhost = true,
  $vhost = undef,
  $vhost_aliases = [],
  $vhost_protected = false,
  $vhost_ssl_only = false,
  $nginx_extra_config = '',
  $nginx_cache = {},
  $alert_5xx_warning_rate = 0.05,
  $alert_5xx_critical_rate = 0.1,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $unicorn_herder_timeout = undef,
  $asset_pipeline = false,
  $asset_pipeline_prefixes = ['assets'],
  $ensure = 'present',
  $hasrestart = false,
  $depends_on_nfs = false,
  $read_timeout = 15,
  $proxy_http_version_1_1_enabled = false,
  $repo_name = undef,
  $sentry_dsn = undef,
  $unicorn_worker_processes = undef,
  $cpu_warning = 150,
  $cpu_critical = 200,
  $collectd_process_regex = undef,
  $alert_when_threads_exceed = 100,
  $alert_when_file_handles_exceed = 500,
  $override_search_location = undef,
  $monitor_unicornherder = undef,
  $local_tcpconns_established_warning = undef,
  $local_tcpconns_established_critical = undef,
  $ensure_service = undef,
) {

  if ! ($app_type in ['procfile', 'rack', 'bare']) {
    fail 'Invalid argument $app_type to govuk::app! Must be one of "procfile", "rack", or "bare"'
  }

  if ($app_type in ['procfile', 'rack']) and ($port == 0) {
    fail 'Must pass port when $app_type is "procfile" or "rack"'
  }

  if ($app_type == 'bare') and !($command) {
    fail 'Invalid $command parameter'
  }

  if ($app_type in ['procfile', 'rack']) {
    validate_integer($port, 65535, 1025)
  }

  validate_re($ensure, '^(present|absent)$', 'Invalid ensure value')

  $vhost_real = $vhost ? {
    undef    => $title,
    default  => $vhost,
  }

  $app_domain = hiera('app_domain')
  if $::aws_migration {
    $vhost_full = $vhost_real
  } else {
    $vhost_full = "${vhost_real}.${app_domain}"
  }

  include govuk::deploy

  govuk::app::package { $title:
    ensure     => $ensure,
    vhost_full => $vhost_full,
    repo_name  => $repo_name,
  }

  govuk::app::config { $title:
    ensure                              => $ensure,
    require                             => Govuk::App::Package[$title],
    app_type                            => $app_type,
    command                             => $command,
    create_pidfile                      => $create_pidfile,
    domain                              => $app_domain,
    port                                => $port,
    vhost_aliases                       => $vhost_aliases,
    vhost_full                          => $vhost_full,
    vhost_protected                     => $vhost_protected,
    vhost_ssl_only                      => $vhost_ssl_only,
    nginx_extra_config                  => $nginx_extra_config,
    nginx_cache                         => $nginx_cache,
    health_check_path                   => $health_check_path,
    health_check_custom_doc             => $health_check_custom_doc,
    json_health_check                   => $json_health_check,
    health_check_service_template       => $health_check_service_template,
    health_check_notification_period    => $health_check_notification_period,
    additional_check_contact_groups     => $additional_check_contact_groups,
    check_period                        => $check_period,
    deny_framing                        => $deny_framing,
    enable_nginx_vhost                  => $enable_nginx_vhost,
    nagios_memory_warning               => $nagios_memory_warning,
    nagios_memory_critical              => $nagios_memory_critical,
    alert_5xx_warning_rate              => $alert_5xx_warning_rate,
    alert_5xx_critical_rate             => $alert_5xx_critical_rate,
    unicorn_herder_timeout              => $unicorn_herder_timeout,
    asset_pipeline                      => $asset_pipeline,
    asset_pipeline_prefixes             => $asset_pipeline_prefixes,
    depends_on_nfs                      => $depends_on_nfs,
    read_timeout                        => $read_timeout,
    sentry_dsn                          => $sentry_dsn,
    proxy_http_version_1_1_enabled      => $proxy_http_version_1_1_enabled,
    unicorn_worker_processes            => $unicorn_worker_processes,
    cpu_warning                         => $cpu_warning,
    cpu_critical                        => $cpu_critical,
    collectd_process_regex              => $collectd_process_regex,
    alert_when_threads_exceed           => $alert_when_threads_exceed,
    alert_when_file_handles_exceed      => $alert_when_file_handles_exceed,
    override_search_location            => $override_search_location,
    monitor_unicornherder               => $monitor_unicornherder,
    local_tcpconns_established_warning  => $local_tcpconns_established_warning,
    local_tcpconns_established_critical => $local_tcpconns_established_critical,
  }

  if $ensure == 'absent' {
    $ensure_service_real = 'absent'
  } else {
    $ensure_service_real = $ensure_service ? {
      undef    => running,
      default  => $ensure_service,
    }
  }

  govuk::app::service { $title:
    ensure     => $ensure_service_real,
    hasrestart => $hasrestart,
    subscribe  => Class['govuk::deploy'],
  }

  @filebeat::prospector { "${title}-upstart-out":
    ensure => $ensure,
    paths  => ["/var/log/${title}/upstart.out.log"],
    tags   => ['stdout', 'upstart'],
    fields => {'application' => $title},
  }
  @filebeat::prospector { "${title}-upstart-err":
    ensure => $ensure,
    paths  => ["/var/log/${title}/upstart.err.log"],
    tags   => ['stderr', 'upstart'],
    fields => {'application' => $title},
  }

  $title_escaped = regsubst($title, '\.', '_', 'G')
  $statsd_timer_prefix = "${::fqdn_metrics}.${title_escaped}"
  $err_log_json = $app_type == 'bare' and $log_format_is_json

  # We still use Logstream for statsd metrics
  govuk_logging::logstream { "${title}-app-out":
    ensure        => $ensure,
    logfile       => "/var/log/${title}/app.out.log",
    tags          => ['application'],
    fields        => {'application' => $title},
    statsd_metric => "${statsd_timer_prefix}.http_%{status}",
    statsd_timers => [{metric => "${statsd_timer_prefix}.time_duration",
                        value => 'duration'},
                      {metric => "${statsd_timer_prefix}.time_db",
                        value => 'db'},
                      {metric => "${statsd_timer_prefix}.time_view",
                        value => 'view'}],
        }

  @filebeat::prospector { "${title}-app-out":
    ensure => $ensure,
    paths  => ["/var/log/${title}/app.out.log"],
    tags   => ['stdout', 'application'],
    json   => true,
    fields => {'application' => $title},
  }

  @filebeat::prospector { "${title}-app-err":
    ensure => $ensure,
    paths  => ["/var/log/${title}/app.err.log"],
    tags   => ['stderr', 'application'],
    json   => $err_log_json,
    fields => {'application' => $title},
  }

  @filebeat::prospector { "${title}_sidekiq_json_log":
    paths  => ["/var/apps/${title}/log/sidekiq*.log"],
    fields => {'application' => $title},
    json   => true,
    tags   => ['sidekiq'],
  }

  # FIXME: when we have migrated all apps to output logs to /var/log this
  # can be removed
  if ($app_type == 'rack' or  $log_format_is_json) {

    $log_path = $log_format_is_json ? {
      true    => "/data/vhost/${vhost_full}/shared/log/production.json.log",
      default => "/data/vhost/${vhost_full}/shared/log/production.log"
    }

    govuk_logging::logstream { "${title}-production-log":
      ensure        => $ensure,
      logfile       => $log_path,
      tags          => ['stdout', 'application'],
      fields        => {'application' => $title},
      statsd_metric => "${statsd_timer_prefix}.http_%{status}",
      statsd_timers => [{metric => "${statsd_timer_prefix}.time_duration",
                          value => 'duration'},
                        {metric => "${statsd_timer_prefix}.time_db",
                          value => 'db'},
                        {metric => "${statsd_timer_prefix}.time_view",
                          value => 'view'}],
    }

    @filebeat::prospector { "${title}-production-log":
      ensure => $ensure,
      paths  => [$log_path],
      tags   => ['stdout', 'application'],
      json   => $log_format_is_json,
      fields => {'application' => $title},
    }
  }
}
