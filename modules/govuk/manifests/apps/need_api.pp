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
# [*mongodb_nodes*]
#   An array of MongoDB instance hostnames
#
# [*mongodb_name*]
#   The name of the MongoDB database to use
#
class govuk::apps::need_api(
  $port = '3052',
  $errbit_api_key = '',
  $mongodb_nodes,
  $mongodb_name = 'govuk_needs_production',
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
  }

  validate_array($mongodb_nodes)
  if $mongodb_nodes != [] {
    $mongodb_nodes_string = join($mongodb_nodes, ',')
    govuk::app::envvar { "${title}-MONGODB_URI":
      varname => 'MONGODB_URI',
      value   => "mongodb://${mongodb_nodes_string}/${mongodb_name}",
    }
  }
}
