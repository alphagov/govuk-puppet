define govuk::app (
  #
  # app_type: 'rack' or 'procfile'.
  #
  # An app_type of 'rack' will assume the presence of a `config.ru` file in
  # the root of the deployed application, and will run the rack up under
  # unicorn.
  #
  # An app_type of 'procfile' will assume the presence of a `Procfile` in the
  # root of the deployed application, which defines a 'web' process type.
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
  $port,

  #
  # logstream: choose whether or not to create a log tailing upstart job
  #
  # If set true, logstream upstart job will be created for a selection of
  # logs we care about.
  #
  $logstream = true,

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
  # intercept_errors: should nginx intercept application errors
  #
  # If set to true, the nginx fronting the application will intercept
  # application errors and serve default error pages
  #
  $intercept_errors = false,

  #
  # platform: the deployment environment to configure
  #
  # You probably don't need to set this explicitly.
  #
  $platform = $::govuk_platform,

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
  # The app will be served at "$vhost.$platform.alphagov.co.uk" in production
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
  # unicorn_herder_timeout: the timeout (in seconds) period to wait for
  #
  # Provides a way to override the default wait period for the 'failed to
  # daemonize' error that occurs if an application doesn't load within
  # the timeout period.
  $unicorn_herder_timeout = undef,
) {

  if ! ($app_type in ['procfile', 'rack']) {
    fail 'Invalid argument $app_type to govuk::app! Must be one of "procfile" or "rack".'
  }

  $vhost_real = $vhost ? {
    undef    => $title,
    default  => $vhost,
  }

  $app_domain = extlookup('app_domain')
  $vhost_full = "${vhost_real}.${app_domain}"

  include govuk::deploy

  govuk::app::package { $title:
    vhost_full => $vhost_full,
  }

  govuk::app::config { $title:
    require                => Govuk::App::Package[$title],
    app_type               => $app_type,
    domain                 => $app_domain,
    port                   => $port,
    vhost_aliases          => $vhost_aliases,
    vhost_full             => $vhost_full,
    vhost_protected        => $vhost_protected,
    vhost_ssl_only         => $vhost_ssl_only,
    nginx_extra_config     => $nginx_extra_config,
    nginx_extra_app_config => $nginx_extra_app_config,
    health_check_path      => $health_check_path,
    intercept_errors       => $intercept_errors,
    enable_nginx_vhost     => $enable_nginx_vhost,
    logstream              => $logstream,
    nagios_cpu_warning     => $nagios_cpu_warning,
    nagios_cpu_critical    => $nagios_cpu_critical,
    unicorn_herder_timeout => $unicorn_herder_timeout,
  }

  govuk::app::service { $title:
    subscribe => Class['govuk::deploy'],
  }

  govuk::logstream { "${title}-upstart-out":
    logfile => "/var/log/${title}/upstart.out.log",
    tags    => ['stdout', 'upstart'],
    fields  => {'application' => $title},
    enable  => $logstream,
  }

  govuk::logstream { "${title}-upstart-err":
    logfile => "/var/log/${title}/upstart.err.log",
    tags    => ['stderr', 'upstart'],
    fields  => {'application' => $title},
    enable  => $logstream,
  }

  if $app_type == 'rack' {
    $title_escaped = regsubst($title, '\.', '_', 'G')
    $statsd_timer_prefix = "${::fqdn_underscore}.${title_escaped}"
    govuk::logstream { "${title}-production-log":
      logfile       => "/data/vhost/${vhost_full}/shared/log/production.log",
      tags          => ['stdout', 'application'],
      fields        => {'application' => $title},
      enable        => $logstream,
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
