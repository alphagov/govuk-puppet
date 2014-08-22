# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define govuk::app (
  #
  # app_type: 'rack', 'procfile', or 'bare'.
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
  $app_type,

  #
  # port: internal HTTP port for the application.
  #
  # If the `app_type` is rack, the -P option will be passed to unicorn
  # automatically. If the `app_type` is 'procfile', then the command run by
  # the Procfile MUST listen on the port defined by the 'PORT' environment
  # variable.
  #
  # Optional, if the `app_type` is 'bare'.
  #
  $port = 'NOTSET',

  #
  # command: command to start the application
  #
  # Used when `app_type` is 'bare'. This will be passed to a variable called
  # `GOVUK_APP_CMD` which is used by `govuk_spinup`.
  #
  $command = undef,

  #
  # logstream: choose whether or not to create a log tailing upstart job
  #
  # If set present, logstream upstart job will be created for a selection of
  # logs we care about.
  #
  $logstream = present,

  #
  # log_format_is_json: logstream file is logstash JSON format
  #
  # If set to true, logstream will consume this as a logstash JSON
  # event formatted stream.
  #
  $log_format_is_json = false,

  #
  # health_check_path: path at which to check the status of the application.
  #
  # This is used to export health checks to ensure the application is running
  # correctly.
  #
  $health_check_path = 'NOTSET',

  #
  # expose_health_check: whether to expose the health check to the proxy.
  #
  # In some apps, such as redirector and bouncer, this must be exposed so load
  # balancers know whether to send requests to a particular server; in other
  # apps, such as publisher, this must not be exposed, because then it would
  # provide an uncached, unauthenticated, publicly accessible point of access
  # into the state of our admin systems.
  $expose_health_check = true,

  #
  # json_health_check: whether the app's health check is exposed as JSON.
  #
  # Some of our apps are adopting a JSON-based healthcheck convention, where
  # there is an overall `status` field that summarises the health of the app,
  # and a `checks` dictionary with the results of individual app-level checks.
  # Setting this to true will add a monitoring check that the healthcheck
  # reports the app's status as OK.
  $json_health_check = false,

  #
  # intercept_errors: should nginx intercept application errors
  #
  # If set to true, the nginx fronting the application will intercept
  # application errors and serve default error pages
  #
  $intercept_errors = false,

  #
  # deny_framing: should we allow this app to be framed
  #
  # If set to true, the nginx fronting the app will set the X-Frame-Options
  # header in such a way as to deny framing in clients that support the header.
  #
  $deny_framing = false,

  #
  # enable_nginx_vhost: should this app be fronted by nginx?
  #
  # Boolean: true or false
  #
  $enable_nginx_vhost = true,

  #
  # vhost: the virtual host prefix for this app
  #
  # Defaults to $title, the name of your application.
  #
  # The app will be served at "$vhost.$app_domain" in production
  # and preview environments.
  #
  $vhost = undef,

  #
  # vhost_aliases: other vhosts on which your app is served
  #
  # Use of this parameter is discouraged: there should preferably be one and
  # only one home for your application. Moreover, all apps are served from a
  # common namespace, and the more names an app has, the greater the chances
  # of a namespace collision.
  #
  $vhost_aliases = [],

  #
  # vhost_protected: should this vhost be protected with HTTP Basic auth?
  #
  # Boolean: true or false
  #
  # Default: undef, which will result in $vhost_protected == false in Skyscape
  # and SCC, true otherwise.
  #
  $vhost_protected = undef,

  #
  # vhost_ssl_only: should this app be served exclusively over HTTPS
  #
  # Boolean: true or false
  #
  $vhost_ssl_only = false,

  #
  # nginx_extra_config: additional nginx configuration for this app
  #
  # This parameter can be used to supply additional nginx configuration
  # directives to be included in your application. In general, use of this
  # parameter indicates that your app is doing something "special", and we
  # should be striving for an infrastructure that contains the smallest
  # possible number of "special cases". As such, use of this option is
  # discouraged, and it is included for backwards compatibility purposes only.
  #
  $nginx_extra_config = '',

  #
  # nginx_extra_app_config: additional @app block configuration
  #
  # This parameter is used to add additional logic (like proxy
  # fallback behaviour) to the default downstream proxy functionality
  # used in Nginx.
  $nginx_extra_app_config = '',

  #
  # nagios_cpu_warning: percentage at which Nagios should generate a warning
  #
  # This parameter is used to change the threshold of the exported nagios
  # cpu usage check. It defaults to 150% for a warning and does not generally
  # need to be altered.
  $nagios_cpu_warning = 150,

  #
  # nagios_cpu_critical: percentage at which Nagios should generate a critical
  #
  # This parameter is used to change the threshold of the exported nagios
  # cpu usage check. It defaults to 200% for a critical and does not generally
  # need to be altered.
  $nagios_cpu_critical = 200,

  #
  # nagios_memory_warning: memory use at which Nagios should generate a warning
  #
  # This parameter is used to change the threshold of the exported nagios
  # memory check. It defaults to 2GB for a warning and does not generally
  # need to be altered. Default is `undef` so we can explicitly pass `undef`
  # to use the default value.
  $nagios_memory_warning = undef,

  #
  # nagios_memory_critical: memory use at which Nagios should generate a critical
  #
  # This parameter is used to change the threshold of the exported nagios
  # memory check. It defaults to 3GB for a critical and does not generally
  # need to be altered. Default is `undef` so we can explicitly pass `undef`
  # to use the default value.
  $nagios_memory_critical = undef,

  #
  # unicorn_herder_timeout: the timeout (in seconds) period to wait for
  #
  # Provides a way to override the default wait period for the 'failed to
  # daemonize' error that occurs if an application doesn't load within
  # the timeout period.
  $unicorn_herder_timeout = undef,

  #
  # upstart_post_start_script: an optional script to be added to a post-start
  # stanza in the upstart config.
  $upstart_post_start_script = undef,

  #
  # asset_pipeline: should we enable some asset pipeline specific rules in the
  # nginx config.
  $asset_pipeline = false,

  #
  # asset_pipeline_prefix: the path prefix from which assets are served.  This should
  # match the application's config.assets.prefix (which defaults to 'assets')
  $asset_pipeline_prefix = 'assets',

  #
  # ensure: allow govuk app to be removed.
  $ensure = 'present',

  #
  # depends_on_nfs: Start the application after mounted filesystems. Some applications
  # depend on NFS shares for functionality. They should not start until the mounted
  # filesystem has been connected. The default for this is false.
  $depends_on_nfs = false,
) {

  if ! ($app_type in ['procfile', 'rack', 'bare']) {
    fail 'Invalid argument $app_type to govuk::app! Must be one of "procfile", "rack", or "bare"'
  }
  if ($app_type in ['procfile', 'rack']) and ($port == 'NOTSET') {
    fail 'Must pass port when $app_type is "procfile" or "rack"'
  }
  if ($app_type == 'bare') and !($command) {
    fail 'Invalid $command parameter'
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
    domain                    => $app_domain,
    port                      => $port,
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
    unicorn_herder_timeout    => $unicorn_herder_timeout,
    upstart_post_start_script => $upstart_post_start_script,
    asset_pipeline            => $asset_pipeline,
    asset_pipeline_prefix     => $asset_pipeline_prefix,
    depends_on_nfs            => $depends_on_nfs,
  }

  govuk::app::service { $title:
    ensure    => $ensure,
    subscribe => Class['govuk::deploy'],
  }

  $logstream_ensure = $ensure ? {
    'present' => $logstream,
    'absent'  => 'absent',
  }

  govuk::logstream { "${title}-upstart-out":
    ensure  => $logstream_ensure,
    logfile => "/var/log/${title}/upstart.out.log",
    tags    => ['stdout', 'upstart'],
    fields  => {'application' => $title},
  }

  govuk::logstream { "${title}-upstart-err":
    ensure  => $logstream_ensure,
    logfile => "/var/log/${title}/upstart.err.log",
    tags    => ['stderr', 'upstart'],
    fields  => {'application' => $title},
  }

  if ($app_type == 'bare' and $log_format_is_json) {
    $err_log_json = true
  } else {
    $err_log_json = undef
  }

  govuk::logstream { "${title}-app-err":
    ensure  => $logstream_ensure,
    logfile => "/var/log/${title}/app.err.log",
    tags    => ['stderr', 'app'],
    json    => $err_log_json,
    fields  => {'application' => $title},
  }

  if ($app_type == 'rack' or  $log_format_is_json) {
    $title_escaped = regsubst($title, '\.', '_', 'G')
    $statsd_timer_prefix = "${::fqdn_underscore}.${title_escaped}"

    $log_path = $log_format_is_json ? {
      true    => "/data/vhost/${vhost_full}/shared/log/production.json.log",
      default => "/data/vhost/${vhost_full}/shared/log/production.log"
    }

    govuk::logstream { "${title}-production-log":
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
                          value => '@fields.view'}]
    }
  }

}
