# == Class: govuk::apps::share_sale_publisher
#
# App to publish shares sale.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3119
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#

class govuk::apps::share_sale_publisher(
  $port = 3119,
  $enabled = false,
  $publishing_api_bearer_token = undef,
) {
  $app_name = 'share-sale-publisher'

  if $enabled {
    govuk::app { $app_name:
      app_type              => 'rack',
      port                  => $port,
      health_check_path     => '/healthcheck',
      log_format_is_json    => true,
      asset_pipeline        => true,
      asset_pipeline_prefix => share-sale-publisher,
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token,
    }
  }
}

