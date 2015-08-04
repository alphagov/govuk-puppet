# == Class: govuk::apps::publishing_api
#
# An application to route requests between multiple content-store
# endpoints based on whether they're live or in other states.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3093
#
# [*content_store*]
#   Is a URL that tells publishing API which content store to save
#   published content in.
#
# [*draft_content_store*]
#   Is a URL that tells publishing API which content store to save
#   draft content in.
#
# [*suppress_draft_store_502_error*]
#   Suppresses "502 Bad Gateway" returned by nginx when publishing API
#   attempts to store draft content. This is intended to be used only
#   during development so that we're not forced to keep draft content
#   store running while testing unrelated features.
#   Default: ''
#
# [*errbit_api_key*]
#   Errbit API key used by gobrake
#   Default: ''
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::publishing_api(
  $port = 3093,
  $content_store = '',
  $draft_content_store = '',
  $suppress_draft_store_502_error = '',
  $errbit_api_key = '',
  $secret_key_base = undef,
) {
  $app_name = 'publishing-api'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    asset_pipeline     => false,
    deny_framing       => true,
  }

  govuk::logstream { "${app_name}-app-out":
    ensure  => absent,
    logfile => "/var/log/${app_name}/app.out.log",
    tags    => ['stdout', 'app'],
    json    => true,
    fields  => {'application' => $app_name},
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    "${title}-CONTENT_STORE":
      varname => 'CONTENT_STORE',
      value   => $content_store;
    "${title}-DRAFT_CONTENT_STORE":
      varname => 'DRAFT_CONTENT_STORE',
      value   => $draft_content_store;
    "${title}-SUPPRESS_DRAFT_STORE_502_ERROR":
      varname => 'SUPPRESS_DRAFT_STORE_502_ERROR',
      value   => $suppress_draft_store_502_error;
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
  }
}
