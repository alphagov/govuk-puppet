# == Class: govuk::apps::collections
#
# Collections is an app to serve collection pages from the content store
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: collections
#
# [*port*]
#   What port should the app run on?
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*enable_new_navigation*]
#   Should we show the new navigation pages?
#
class govuk::apps::collections(
  $vhost = 'collections',
  $port = '3070',
  $errbit_api_key = undef,
  $secret_key_base = undef,
  $enable_new_navigation = undef
) {
  govuk::app { 'collections':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/topic/oil-and-gas',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'collections',
    vhost                 => $vhost,
  }

  Govuk::App::Envvar {
    app => 'collections',
  }

  govuk::app::envvar {
    "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    "${title}-ENABLE_NEW_NAVIGATION":
        varname => 'ENABLE_NEW_NAVIGATION',
        value   => $enable_new_navigation;
  }
}
