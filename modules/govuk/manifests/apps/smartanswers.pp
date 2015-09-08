# == Class: govuk::apps::smartanswers
#
# Configures Smart Answers application
#
# === Parameters
#
# [*port*]
#   The port that Smart Answers is served on.
#   Default: 3010
#
# [*expose_govspeak*]
#   Either 'true' or 'false' indicating if govspeak format should be made
#   available alongside other formats (e.g. html, json)
#   Default: 'false'

class govuk::apps::smartanswers(
  $port = 3010,
  $expose_govspeak = 'false',
) {

  Govuk::App::Envvar {
    app => 'smartanswers',
  }

  govuk::app::envvar {
    'EXPOSE_GOVSPEAK':
      value => $expose_govspeak;
  }

  govuk::app { 'smartanswers':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/pay-leave-for-parents',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'smartanswers',
  }
}
