# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::email_campaign_frontend(
  $port = 3109,
  $enabled = true,
  $errbit_api_key = undef,
  $secret_key_base = undef,
) {
  $app_name = 'email-campaign-frontend'

  if $enabled {
    govuk::app { $app_name:
      app_type              => 'rack',
      port                  => $port,
      health_check_path     => '/healthcheck',
      log_format_is_json    => true,
      asset_pipeline        => true,
      asset_pipeline_prefix => 'email-campaign-frontend',
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    if $errbit_api_key != undef {
      govuk::app::envvar {
        "${title}-ERRBIT_API_KEY":
          varname => 'ERRBIT_API_KEY',
          value   => $errbit_api_key;
      }
    }

    if $secret_key_base != undef {
      govuk::app::envvar { "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base,
      }
    }
  }
}
