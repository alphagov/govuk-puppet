# govuk::apps::feedback
#
# The GOV.UK Feedback application -- handles user feedback and support submissions
#
# === Parameters
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*support_bearer_token*]
#   The bearer token to allow this app to submit anonymous feedback to the Support App.
#
# [*support_api_bearer_token*]
#   The bearer token to allow this app to submit anonymous feedback to the Support API.
#
# [*govuk_notify_api_key*]
#   The API key to allow this app to talk to GOV.UK Notify and send emails
#   to people who want to sign up to take a survey
#
# [*govuk_notify_survey_signup_template_id*]
#   Survey signup template ID for GOV.UK Notify
#
# [*govuk_notify_survey_signup_reply_to_id*]
#   Survey signup email address reply_to ID for GOV.UK Notify
#
# [*govuk_notify_accessible_format_request_template_id*]
#   Accessible format request template ID for GOV.UK Notify
#
# [*govuk_notify_accessible_format_request_reply_to_id*]
#   Accessible format request email address reply_to ID for GOV.UK Notify
#
# [*govuk_rate_limit_token*]
#   Token shared with Smokey to bypass the rate limiter
#
# [*redis_host*]
#   Redis host for Rack::Attack.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Rack::Attack.
#   Default: undef
#
class govuk::apps::feedback(
  $port,
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $support_bearer_token = undef,
  $support_api_bearer_token = undef,
  $publishing_api_bearer_token = undef,
  $assisted_digital_google_spreadsheet_key = undef,
  $google_client_email = undef,
  $google_private_key = undef,
  $govuk_notify_api_key,
  $govuk_notify_survey_signup_template_id,
  $govuk_notify_survey_signup_reply_to_id,
  $govuk_notify_accessible_format_request_template_id = undef,
  $govuk_notify_accessible_format_request_reply_to_id = undef,
  $govuk_rate_limit_token,
  $redis_host = undef,
  $redis_port = undef,
) {
  $app_name = 'feedback'

  govuk::app { $app_name:
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    log_format_is_json         => true,
    asset_pipeline             => true,
    asset_pipeline_prefixes    => ['assets/feedback'],
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  if $support_bearer_token != undef {
    govuk::app::envvar { "${title}-SUPPORT_BEARER_TOKEN":
      varname => 'SUPPORT_BEARER_TOKEN',
      value   => $support_bearer_token,
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

  govuk::app::envvar { "${title}-GOVUK_NOTIFY_API_KEY":
    varname => 'GOVUK_NOTIFY_API_KEY',
    value   => $govuk_notify_api_key,
  }

  govuk::app::envvar { "${title}-GOVUK_NOTIFY_SURVEY_SIGNUP_TEMPLATE_ID":
    varname => 'GOVUK_NOTIFY_SURVEY_SIGNUP_TEMPLATE_ID',
    value   => $govuk_notify_survey_signup_template_id,
  }

  govuk::app::envvar { "${title}-GOVUK_NOTIFY_SURVEY_SIGNUP_REPLY_TO_ID":
    varname => 'GOVUK_NOTIFY_SURVEY_SIGNUP_REPLY_TO_ID',
    value   => $govuk_notify_survey_signup_reply_to_id,
  }

  govuk::app::envvar { "${title}-GOVUK_NOTIFY_ACCESSIBLE_FORMAT_REQUEST_TEMPLATE_ID":
    varname => 'GOVUK_NOTIFY_ACCESSIBLE_FORMAT_REQUEST_TEMPLATE_ID',
    value   => $govuk_notify_accessible_format_request_template_id,
  }

  govuk::app::envvar { "${title}-GOVUK_NOTIFY_ACCESSIBLE_FORMAT_REQUEST_REPLY_TO_ID":
    varname => 'GOVUK_NOTIFY_ACCESSIBLE_FORMAT_REQUEST_REPLY_TO_ID',
    value   => $govuk_notify_accessible_format_request_reply_to_id,
  }

    govuk::app::envvar { "${title}-GOVUK_RATE_LIMIT_TOKEN":
      varname => 'GOVUK_RATE_LIMIT_TOKEN',
      value   => $govuk_rate_limit_token,
    }

  if $redis_host != undef {
    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }
  }
}
