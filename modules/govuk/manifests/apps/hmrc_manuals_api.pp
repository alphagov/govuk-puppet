# == Class: govuk::apps::hmrc_manuals_api
#
# An API to allow HMRC to publish tax manuals to GOV.UK.
# Read more: https://github.com/alphagov/hmrc-manuals-api
#
# === Parameters
#
# [*port*]
#   The port that hmrc-manuals-api is served on.
#   Default: 3071
#
# [*enabled*]
#   Feature flag to allow the app to be deployed to an environment.
#   Default: false
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*publish_topics*]
#   Feature flag to allow publishing of manual topics to the Publishing
#   API and Rummager.
#   Default: false
#
class govuk::apps::hmrc_manuals_api(
  $port = 3071,
  $enable_procfile_worker = true,
  $publish_topics = false,
) {

  Govuk::App::Envvar {
    app => 'hmrc_manuals_api',
  }

  if $publish_topics {
    govuk::app::envvar {
      "${title}-PUBLISH_TOPICS":
        varname => 'PUBLISH_TOPICS',
        value => '1';
    }
  }

  govuk::app { 'hmrc-manuals-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  govuk::procfile::worker {'hmrc-manuals-api':
    enable_service => $enable_procfile_worker,
  }
}
