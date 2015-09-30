# govuk::apps::feedback
#
# The GOV.UK Feedback application -- handles user feedback and support submissions
#
# === Parameters
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*support_api_bearer_token*]
#   The bearer token to allow this app to submit anonymous feedback to the Support API.
#
class govuk::apps::feedback(
  $port = '3028',
  $errbit_api_key = undef,
  $secret_key_base = undef,
  $support_api_bearer_token = undef,
) {
  $app_name = 'feedback'

  govuk::app { $app_name:
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/contact',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => $app_name,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  if $errbit_api_key {
    govuk::app::envvar { "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key,
    }
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  if $support_api_bearer_token != undef {
    govuk::app::envvar { "${title}-SUPPORT_API_BEARER_TOKEN":
      varname => 'SUPPORT_API_BEARER_TOKEN',
      value   => $support_api_bearer_token,
    }
  }
}
