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

  # health_check_port used by load balancers to check health of service
  $health_check_port = 'NOTSET',

  #
  # platform: the deployment environment to configure
  #
  # You probably don't need to set this explicitly.
  #
  $platform = $::govuk_platform,

  #
  # environ_content: contents of the envmgr config file loaded for this app
  #
  # This can be used to define the contents of an
  # [envmgr](https://github.com/nickstenning/envmgr) config file which is
  # loaded before your application. This file can be used to control the
  # environment variables available to the application:
  #
  #     govuk::app { 'foo':
  #       [...]
  #       environ_content => "SECRET_KEY=2DD6A5F73278",
  #     }
  #
  #     govuk::app { 'foo':
  #       [...]
  #       environ_content => template('govuk/apps/foo_environment.conf'),
  #     }
  #
  $environ_content = undef,

  #
  # environ_source: source of the envmgr config file loaded for this app
  #
  # Same as environ_content but using Puppet's `source` parameter.
  #
  $environ_source = undef,

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
  $vhost_protected = true,

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
  $nginx_extra_config = ''
) {

  if ! ($app_type in ['procfile', 'rack']) {
    fail 'Invalid argument $app_type to govuk::app! Must be one of "procfile" or "rack".'
  }

  $vhost_real = $vhost ? {
    undef    => $title,
    default  => $vhost,
  }

  $domain = $platform ? {
    'development' => 'dev.gov.uk',
    default       => "${platform}.alphagov.co.uk",
  }

  $vhost_full = "${vhost_real}.${domain}"

  include govuk::deploy

  govuk::app::package { $title:
    vhost_full => $vhost_full,
    platform   => $platform,
  }

  govuk::app::config { $title:
    require            => Govuk::App::Package[$title],
    notify             => Service[$title],
    environ_source     => $environ_source,
    environ_content    => $environ_content,
    domain             => $domain,
    port               => $port,
    vhost_aliases      => $vhost_aliases,
    vhost_full         => $vhost_full,
    vhost_protected    => $vhost_protected,
    vhost_ssl_only     => $vhost_ssl_only,
    nginx_extra_config => $nginx_extra_config,
    platform           => $platform,
    health_check_path  => $health_check_path,
    health_check_port  => $health_check_port,
  }

  service { $title:
    provider  => upstart,
    subscribe => Class['govuk::deploy'],
  }

  if $platform != 'development' {
    Service[$title] {
      ensure => running
    }
  }
}
