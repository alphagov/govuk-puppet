# == Class: govuk::apps::licencefinder
#
# An application for finding licences on gov.uk
#
# === Parameters
#
# [*port*]
#   The port that licence finder is served on.
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
class govuk::apps::licencefinder(
  $port = '3014',
  $errbit_api_key = undef,
  $mongodb_nodes,
  $mongodb_name = 'licence_finder_production',
) {

  $app_name = 'licencefinder'

  govuk::app { $app_name:
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/licence-finder',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'licencefinder',
  }

  if $errbit_api_key {
    govuk::app::envvar {
      "${title}-ERRBIT_API_KEY":
        app     => $app_name,
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
    }
  }

  if $::govuk_node_class != 'development' {
    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }
  }
}
