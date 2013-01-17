define govuk::app(
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

  # health_check_path used by load balancers to check health of service
  $health_check_path = 'NOTSET',

  #
  # intercept_errors: should nginx intercept application errors
  #
  # If set to true, the nginx fronting the application will intercept
  # application errors and serve default error pages
  #
  $intercept_errors = false,

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
  # The app will be served at "$vhost.$app_domain".
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
  $nginx_extra_app_config = ''
) {

  if ! ($app_type in ['procfile', 'rack']) {
    fail 'Invalid argument $app_type to govuk::app! Must be one of "procfile" or "rack".'
  }

  $vhost_real = $vhost ? {
    undef    => $title,
    default  => $vhost,
  }

  $domain = extlookup('app_domain')
  $vhost_full = "${vhost_real}.${domain}"

  include govuk::deploy

  govuk::app::package { $title:
    vhost_full => $vhost_full,
    platform   => $platform,
  }

  govuk::app::config { $title:
    require                => Govuk::App::Package[$title],
    app_type               => $app_type,
    domain                 => $domain,
    port                   => $port,
    vhost_aliases          => $vhost_aliases,
    vhost_full             => $vhost_full,
    vhost_protected        => $vhost_protected,
    vhost_ssl_only         => $vhost_ssl_only,
    nginx_extra_config     => $nginx_extra_config,
    nginx_extra_app_config => $nginx_extra_app_config,
    platform               => $platform,
    health_check_path      => $health_check_path,
    intercept_errors       => $intercept_errors,
    enable_nginx_vhost     => $enable_nginx_vhost,
  }

  govuk::app::service { $title:
    platform  => $platform,
    subscribe => Class['govuk::deploy'],
  }

}
