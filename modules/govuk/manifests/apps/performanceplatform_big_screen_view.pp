# == Class: govuk::apps::performanceplatform_big_screen_view
#
# Big screen view displays a view of dashboards on the performance platform
# optimised for big screens
#
# === Parameters
#
# [*enabled*]
#   Whether the app is enabled.
#   Default: true
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::performanceplatform_big_screen_view (
  $enabled = false,
  $publishing_api_bearer_token = undef,
) {
  include govuk::deploy

  if $enabled {
    $app_domain = hiera('app_domain')
    $app_name = 'performanceplatform-big-screen-view'
    $vhost_full = "${app_name}.${app_domain}"
    govuk::app::package { $app_name:
      ensure     => present,
      vhost_full => $vhost_full,
    }
    govuk::app::nginx_vhost { $app_name:
      ensure          => present,
      single_page_app => '/performance/big-screen/index.html',
      vhost           => $vhost_full,
      ssl_only        => true,
      app_port        => 3058,
    }
    govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
      app     => $app_name,
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token,
    }
  }
}
