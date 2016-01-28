# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::financial_publisher(
  $port = 3118,
  $enabled = false,
  $publishing_api_bearer_token = undef,
) {
  $app_name = 'financial-publisher'

  if $enabled {
    govuk::app { $app_name:
      app_type              => 'rack',
      port                  => $port,
      health_check_path     => '/healthcheck',
      log_format_is_json    => true,
      asset_pipeline        => true,
      asset_pipeline_prefix => financial-publisher,
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

