# Class: govuk::apps::local_links_manager
#
# App to manage the local links within GOV.UK so that
# they can be used for local transactions.
# https://github.com/alphagov/local-links-manager
#
# [*port*]
#   What port should the app run on?
#
# [*enabled*]
#   Should the app exist?
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*secret_key_base*]
#   Used to set the app ENV var SECRET_KEY_BASE which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
class govuk::apps::local_links_manager(
  $port = 3121,
  $enabled = false,
  $errbit_api_key = undef,
  $secret_key_base = undef,
) {
  if $enabled {
    govuk::app { 'local-links-manager':
      app_type          => 'rack',
      port              => $port,
      vhost_ssl_only    => true,
      health_check_path => '/healthcheck',
    }
  }

  Govuk::App::Envvar {
    app    => 'local-links-manager',
  }

  govuk::app::envvar {
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
  }
}
