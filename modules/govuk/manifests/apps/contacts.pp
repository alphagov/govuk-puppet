# == Class: govuk::apps::contacts
#
# An application to route requests between multiple content-store
# endpoints based on whether they're live or in other states.
#
# === Parameters
#
# [*enabled*]
#   Whether the app is enabled.
#   Default: true
#
# [*vhost*]
#   Virtual host for this application.
#   Default: contacts
#
# [*port*]
#   The port that the app is served on.
#   Default: 3051
#
# [*vhost_protected*]
#   Should this vhost be protected with HTTP Basic auth?
#   Default: undef
#
# [*extra_aliases*]
#   Other vhosts on which the app is served.
#   Default: []
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::contacts(
  $enabled = true,
  $vhost = 'contacts',
  $port = '3051',
  $vhost_protected = undef,
  $extra_aliases = [],
  $publishing_api_bearer_token = undef,
) {

  validate_array($extra_aliases)

  if $enabled {
    govuk::app { 'contacts':
      app_type              => 'rack',
      vhost                 => $vhost,
      port                  => $port,
      health_check_path     => '/healthcheck',
      vhost_protected       => $vhost_protected,
      asset_pipeline        => true,
      asset_pipeline_prefix => 'contacts-assets',
      vhost_aliases         => $extra_aliases,
      nginx_extra_config    => '
        # Don\'t ask for basic auth on SSO API pages so we can sync
        # permissions.
        location /auth/gds {
          auth_basic off;
          try_files $uri @app;
        }
      ',
    }

    govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
      app     => 'contacts',
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token,
    }
  }
}
