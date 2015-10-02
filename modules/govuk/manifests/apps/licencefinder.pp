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
class govuk::apps::licencefinder(
  $port = '3014',
  $errbit_api_key = undef,
) {

  $app_name = 'licencefinder'

  govuk::app { $app_name:
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/licence-finder',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => $app_name,
  }

  if $errbit_api_key {
    govuk::app::envvar {
      "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
    }
  }
}
