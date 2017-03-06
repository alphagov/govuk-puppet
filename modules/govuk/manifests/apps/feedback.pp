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
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*support_api_bearer_token*]
#   The bearer token to allow this app to submit anonymous feedback to the Support API.
#
# [*survey_notify_service_api_key*]
#   The API key to allow this app to talk to GOV.UK Notify and send emails
#   to people who want to sign up to take a survey
#
class govuk::apps::feedback(
  $port = '3028',
  $errbit_api_key = undef,
  $secret_key_base = undef,
  $support_api_bearer_token = undef,
  $publishing_api_bearer_token = undef,
  $assisted_digital_google_spreadsheet_key = undef,
  $google_client_email = undef,
  $google_private_key = undef,
  $survey_notify_service_api_key = undef,
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

  govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
    varname => 'PUBLISHING_API_BEARER_TOKEN',
    value   => $publishing_api_bearer_token,
  }

  if $assisted_digital_google_spreadsheet_key != undef {
    govuk::app::envvar { "${title}-ASSISTED_DIGITAL_GOOGLE_SPREADSHEET_KEY":
      varname => 'ASSISTED_DIGITAL_GOOGLE_SPREADSHEET_KEY',
      value   => $assisted_digital_google_spreadsheet_key,
    }
  }

  if $google_client_email != undef {
    govuk::app::envvar { "${title}-GOOGLE_CLIENT_EMAIL":
      varname => 'GOOGLE_CLIENT_EMAIL',
      value   => $google_client_email,
    }
  }

  if $google_private_key != undef {
    govuk::app::envvar { "${title}-GOOGLE_PRIVATE_KEY":
      varname => 'GOOGLE_PRIVATE_KEY',
      value   => $google_private_key,
    }
  }

  if $survey_notify_service_api_key != undef {
    govuk::app::envvar { "${title}-SURVEY_NOTIFY_SERVICE_API_KEY":
      varname => 'SURVEY_NOTIFY_SERVICE_API_KEY',
      value   => $survey_notify_service_api_key,
    }
  }
}
