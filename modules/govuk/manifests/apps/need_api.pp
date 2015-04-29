# == Class: govuk::apps::need_api
#
# An application to maintain all the user needs for GOV.UK.  This presents an
# API for managing them.  See maslow for the UI that consumes this.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3093
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*errbit_environment_name*]
#   Errbit environment name, one of preview, staging or production
#   Default: ''
#
class govuk::apps::need_api(
  $port = 3052,
  $errbit_api_key = '',
  $errbit_environment_name = '',
) {
  govuk::app { 'need-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  govuk::logstream { 'need-api-org-import-json-log':
    logfile => '/var/apps/need-api/log/organisation_import.json.log',
    fields  => {'application' => 'need-api'},
    json    => true,
  }

  Govuk::App::Envvar {
    app => 'need-api',
  }
  govuk::app::envvar {
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    "${title}-ERRBIT_ENVIRONMENT_NAME":
      varname => 'ERRBIT_ENVIRONMENT_NAME',
      value   => $errbit_environment_name;
  }
}
