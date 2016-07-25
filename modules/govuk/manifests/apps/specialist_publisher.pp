# == Class: govuk::apps::specialist_publisher
#
# Publishing App for specialist documents and manuals.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3064
#
# [*enabled*]
#   Whether the app is enabled.
#   Default: false
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true

# [*publish_pre_production_finders*]
#   Whether to enable publishing of pre-production finders
#   Default: false
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*email_alert_api_bearer_token*]
#   The bearer token to use when communicating with Email Alert API.
#   Default: undef
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
class govuk::apps::specialist_publisher(
  $port = '3064',
  $enabled = false,
  $enable_procfile_worker = true,
  $publish_pre_production_finders = false,
  $publishing_api_bearer_token = undef,
  $email_alert_api_bearer_token = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
) {

  if $enabled {
    govuk::app { 'specialist-publisher':
      app_type               => 'rack',
      port                   => $port,
      health_check_path      => '/specialist-documents',
      log_format_is_json     => true,
      nginx_extra_config     => '
client_max_body_size 500m;
',
      nagios_memory_warning  => $nagios_memory_warning,
      nagios_memory_critical => $nagios_memory_critical,
    }

    Govuk::App::Envvar {
      app => 'specialist-publisher',
    }

    if $publish_pre_production_finders {
      govuk::app::envvar {
        "${title}-PUBLISH_PRE_PRODUCTION_FINDERS":
          varname => 'PUBLISH_PRE_PRODUCTION_FINDERS',
          value   => '1';
      }
    }

    govuk::procfile::worker { 'specialist-publisher':
      enable_service => $enable_procfile_worker,
    }

    govuk::app::envvar {
      "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
      "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
      varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
      value   => $email_alert_api_bearer_token;
    }
  }
}
