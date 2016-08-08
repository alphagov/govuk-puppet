# == Class: govuk::apps::email_campaign_api
#
# Email Campaign API is an internal API for posting captured emails
# (ones interested in buying Lloyds shares) to gov_delivery.
#
# === Parameters
#
# [*gov_delivery_endpoint*]
#   URL for gov delivery to post email in xml format.
#
# [*gov_delivery_code*]
#   gov_delivery has a topic under which all these subcribers (emails) will be stored.
#   This code corresponds to that topic.
#
# [*gov_delivery_username*]
#   gov_delivery basic authentication username.
#
# [*gov_delivery_password*]
#   gov_delivery basic authentication password.
#
# [*redis_host*]
#   Redis host.
#
# [*redis_port*]
#   Redis port.
#
class govuk::apps::email_campaign_api(
  $port = 3110,
  $enabled = true,
  $enable_procfile_worker = true,
  $errbit_api_key = undef,
  $secret_key_base = undef,
  $gov_delivery_endpoint = undef,
  $gov_delivery_code = undef,
  $gov_delivery_username = undef,
  $gov_delivery_password = undef,
  $redis_host='api-redis-1.api',
  $redis_port= undef,
  $mongodb_nodes,
  $mongodb_name = 'email_campaign_api',
) {
  $app_name = 'email-campaign-api'

  if $enabled {
    govuk::app { $app_name:
      app_type           => 'rack',
      port               => $port,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }

    govuk::procfile::worker {'email-campaign-api':
      enable_service => $enable_procfile_worker,
    }

    govuk_logging::logstream { 'email_campaign_api_sidekiq_json_log':
      logfile => '/var/apps/email-campaign-api/log/sidekiq.json.log',
      fields  => {'application' => 'email-campaign-api-sidekiq'},
      json    => true,
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    govuk::app::envvar {
      "${title}-ERRBIT_API_KEY":
          varname => 'ERRBIT_API_KEY',
          value   => $errbit_api_key;
      "${title}-SECRET_KEY_BASE":
          varname => 'SECRET_KEY_BASE',
          value   => $secret_key_base;
      "${title}-GOV_DELIVERY_ENDPOINT":
          varname => 'GOV_DELIVERY_ENDPOINT',
          value   => $gov_delivery_endpoint;
      "${title}-GOV_DELIVERY_CODE":
          varname => 'GOV_DELIVERY_CODE',
          value   => $gov_delivery_code;
      "${title}-GOV_DELIVERY_USERNAME":
          varname => 'GOV_DELIVERY_USERNAME',
          value   => $gov_delivery_username;
      "${title}-GOV_DELIVERY_PASSWORD":
          varname => 'GOV_DELIVERY_PASSWORD',
          value   => $gov_delivery_password;
    }
  }
}
