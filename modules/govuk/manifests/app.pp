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
# [*custom_http_host*]
# This setting allows the default HTTP Host header to be overridden.
#
# An example of where this is useful is if requests are handled by different
# backend applications but use the same hostname.
# Default: undef
#
# [*logstream*]
# choose whether or not to create a log tailing upstart job
#
# If set present, logstream upstart job will be created for a selection of
# logs we care about.
#
#
# [*legacy_logging*]
# Whether to support the legacy logging scheme where we collect application
# logs directly, instead of having logs log to stdout/stderr.
# Default: true
#
#
# [*log_format_is_json*]
# Whether the legacy application logs are in JSON format. If set to true,
# logstream will consume this as a logstash JSON event formatted stream.
#
# This is ignored unless legacy_logging is set to true.
#
# Default: false
#
#
# [*health_check_path*]
# path at which to check the status of the application.
#
# This is used to export health checks to ensure the application is running
# correctly.
#
#
# [*expose_health_check*]
# whether to expose the health check to the proxy.
#
# In some apps, such as bouncer, this must be exposed so load balancers know
# whether to send requests to a particular server; in other apps, such as
# publisher, this must not be exposed, because then it would provide an
# uncached, unauthenticated, publicly accessible point of access into the
# state of our admin systems.
#
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
#
# [*intercept_errors*]
# should nginx intercept application errors
#
# If set to true, the nginx fronting the application will intercept
# application errors and serve default error pages
#
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
#
# [*nginx_extra_app_config*]
# additional @app block configuration
#
# This parameter is used to add additional logic (like proxy
# fallback behaviour) to the default downstream proxy functionality
# used in Nginx.
#
#
# [*nagios_cpu_warning*]
# percentage at which Nagios should generate a warning
#
# This parameter is used to change the threshold of the exported nagios
# cpu usage check. It defaults to 150% for a warning and does not generally
# need to be altered.
#
#
# [*nagios_cpu_critical*]
# percentage at which Nagios should generate a critical
#
# This parameter is used to change the threshold of the exported nagios
# cpu usage check. It defaults to 200% for a critical and does not generally
# need to be altered.
#
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
#
# [*upstart_post_start_script*]
# an optional script to be added to a post-start
# stanza in the upstart config.
#
#
# [*asset_pipeline*]
# should we enable some asset pipeline specific rules in the
# nginx config.
#
#
# [*asset_pipeline_prefix*]
# the path prefix from which assets are served.  This should
# match the application's config.assets.prefix (which defaults to 'assets')
#
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
define govuk::app (
  $app_type,
  $port = 0,
  $command = undef,
  $create_pidfile = 'NOTSET',
  $custom_http_host = undef,
  $logstream = present,
  $legacy_logging = true,
  $log_format_is_json = false,
  $health_check_path = 'NOTSET',
  $expose_health_check = true,
  $json_health_check = false,
  $intercept_errors = false,
  $deny_framing = false,
  $enable_nginx_vhost = true,
  $vhost = undef,
  $vhost_aliases = [],
  $vhost_protected = false,
  $vhost_ssl_only = false,
  $nginx_extra_config = '',
  $nginx_extra_app_config = '',
  $nagios_cpu_warning = 150,
  $nagios_cpu_critical = 200,
  $alert_5xx_warning_rate = 0.05,
  $alert_5xx_critical_rate = 0.1,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $unicorn_herder_timeout = undef,
  $upstart_post_start_script = undef,
  $asset_pipeline = false,
  $asset_pipeline_prefix = 'assets',
  $ensure = 'present',
  $hasrestart = false,
  $depends_on_nfs = false,
  $read_timeout = 15,
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
  $vhost_full = "${vhost_real}.${app_domain}"

  include govuk::deploy

  govuk::app::package { $title:
    ensure     => $ensure,
    vhost_full => $vhost_full,
  }

  govuk::app::config { $title:
    ensure                    => $ensure,
    require                   => Govuk::App::Package[$title],
    app_type                  => $app_type,
    command                   => $command,
    create_pidfile            => $create_pidfile,
    domain                    => $app_domain,
    port                      => $port,
    custom_http_host          => $custom_http_host,
    vhost_aliases             => $vhost_aliases,
    vhost_full                => $vhost_full,
    vhost_protected           => $vhost_protected,
    vhost_ssl_only            => $vhost_ssl_only,
    nginx_extra_config        => $nginx_extra_config,
    nginx_extra_app_config    => $nginx_extra_app_config,
    health_check_path         => $health_check_path,
    expose_health_check       => $expose_health_check,
    json_health_check         => $json_health_check,
    intercept_errors          => $intercept_errors,
    deny_framing              => $deny_framing,
    enable_nginx_vhost        => $enable_nginx_vhost,
    logstream                 => $logstream,
    nagios_cpu_warning        => $nagios_cpu_warning,
    nagios_cpu_critical       => $nagios_cpu_critical,
    nagios_memory_warning     => $nagios_memory_warning,
    nagios_memory_critical    => $nagios_memory_critical,
    alert_5xx_warning_rate    => $alert_5xx_warning_rate,
    alert_5xx_critical_rate   => $alert_5xx_critical_rate,
    unicorn_herder_timeout    => $unicorn_herder_timeout,
    upstart_post_start_script => $upstart_post_start_script,
    asset_pipeline            => $asset_pipeline,
    asset_pipeline_prefix     => $asset_pipeline_prefix,
    depends_on_nfs            => $depends_on_nfs,
    read_timeout              => $read_timeout,
  }

  govuk::app::service { $title:
    ensure     => $ensure,
    hasrestart => $hasrestart,
    subscribe  => Class['govuk::deploy'],
  }

  $logstream_ensure = $ensure ? {
    'present' => $logstream,
    'absent'  => 'absent',
  }

  govuk_logging::logstream { "${title}-upstart-out":
    ensure  => $logstream_ensure,
    logfile => "/var/log/${title}/upstart.out.log",
    tags    => ['stdout', 'upstart'],
    fields  => {'application' => $title},
  }

  govuk_logging::logstream { "${title}-upstart-err":
    ensure  => $logstream_ensure,
    logfile => "/var/log/${title}/upstart.err.log",
    tags    => ['stderr', 'upstart'],
    fields  => {'application' => $title},
  }

  $title_escaped = regsubst($title, '\.', '_', 'G')
  $statsd_timer_prefix = "${::fqdn_metrics}.${title_escaped}"

  if $legacy_logging {
    if ($app_type == 'bare' and $log_format_is_json) {
      $err_log_json = true
    } else {
      $err_log_json = undef
    }

    govuk_logging::logstream { "${title}-app-err":
      ensure  => $logstream_ensure,
      logfile => "/var/log/${title}/app.err.log",
      tags    => ['stderr', 'app'],
      json    => $err_log_json,
      fields  => {'application' => $title},
    }

    if ($app_type == 'rack' or  $log_format_is_json) {

      $log_path = $log_format_is_json ? {
        true    => "/data/vhost/${vhost_full}/shared/log/production.json.log",
        default => "/data/vhost/${vhost_full}/shared/log/production.log"
      }

      govuk_logging::logstream { "${title}-production-log":
        ensure        => $logstream_ensure,
        logfile       => $log_path,
        tags          => ['stdout', 'application'],
        fields        => {'application' => $title},
        json          => $log_format_is_json,
        statsd_metric => "${statsd_timer_prefix}.http_%{@field.status}",
        statsd_timers => [{metric => "${statsd_timer_prefix}.time_duration",
                            value => '@fields.duration'},
                          {metric => "${statsd_timer_prefix}.time_db",
                            value => '@fields.db'},
                          {metric => "${statsd_timer_prefix}.time_view",
                            value => '@fields.view'}],
      }
    }

  } else {
    govuk_logging::logstream { "${title}-app-out":
      ensure        => $logstream_ensure,
      logfile       => "/var/log/${title}/app.out.log",
      tags          => ['application'],
      json          => true,
      fields        => {'application' => $title},
      statsd_metric => "${statsd_timer_prefix}.http_%{@field.status}",
      statsd_timers => [{metric => "${statsd_timer_prefix}.time_duration",
                          value => '@fields.duration'},
                        {metric => "${statsd_timer_prefix}.time_db",
                          value => '@fields.db'},
                        {metric => "${statsd_timer_prefix}.time_view",
                          value => '@fields.view'}],
    }

    govuk_logging::logstream { "${title}-app-err":
      ensure  => $logstream_ensure,
      logfile => "/var/log/${title}/app.err.log",
      tags    => ['application'],
      fields  => {'application' => $title},
    }

    # Support apps transitioning from legacy_logging.
    govuk_logging::logstream { "${title}-production-log":
      ensure  => absent,
      logfile => "/data/vhost/${vhost_full}/shared/log/production.log",
    }
  }

}
