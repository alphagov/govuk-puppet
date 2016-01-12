# Multipage-frontend is a Ruby on Rails frontend application
# for rendering content grouped in multiple parts or pages.
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
class govuk::apps::multipage_frontend(
  $vhost,
  $port = '3118',
  $enabled = false,
  $errbit_api_key = undef,
  $secret_key_base = undef,
) {
  if $enabled {
    govuk::app { 'multipage-frontend':
      app_type              => 'rack',
      port                  => $port,
      asset_pipeline        => true,
      asset_pipeline_prefix => 'multipage-frontend',
      vhost                 => $vhost,
      health_check_path     => '/healthcheck',
    }

    Govuk::App::Envvar {
      app    => 'multipage-frontend'
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
}
