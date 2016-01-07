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
#   A boolean value indicating if govspeak format should be made
#   available alongside other formats (e.g. html, json)
#   Default: false
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::smartanswers(
  $port = '3010',
  $expose_govspeak = false,
  $publishing_api_bearer_token = undef,
) {
  Govuk::App::Envvar {
    app => 'smartanswers',
  }

  if $expose_govspeak {
    govuk::app::envvar {
      "${title}-EXPOSE_GOVSPEAK":
        varname => 'EXPOSE_GOVSPEAK',
        value   => '1';
    }
  }

  govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
    varname => 'PUBLISHING_API_BEARER_TOKEN',
    value   => $publishing_api_bearer_token,
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
