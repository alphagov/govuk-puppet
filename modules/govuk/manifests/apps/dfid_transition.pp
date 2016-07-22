# == Class: govuk::apps::dfid_transition
#
# Helps in managing the DFID research outputs import by allowing
# us to enqueue transition operations (such as downloading the
# outputs' PDFs). This 'app' has a shelf life which expires
# when dfid-transition does.
#
# Read more: https://github.com/alphagov/dfid-transition
#
# === Parameters
#
# [*port*]
#   Not used.
#   Default: 9999
#
# [*enabled*]
#   Whether the app should exist
#   Default: false
#
# [*enabled_procfile_worker*]
#   Whether the procfile worker is enabled
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#   Default: undef
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*redis_host*]
#   Redis host for sidekiq and AttachmentIndex.
#
# [*redis_port*]
#   Redis port for sidekiq and AttachmentIndex.
#   Default: 6379
class govuk::apps::dfid_transition (
  $port = 3124,
  $enabled = false,
  $enable_procfile_worker = undef,
  $asset_manager_bearer_token = undef,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
) {
  $app_name = 'dfid-transition'

  if $enabled {
    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::procfile::worker {$app_name:
      enable_service => $enable_procfile_worker,
    }

    govuk::app::envvar {
      "${title}-ASSET_MANAGER_BEARER_TOKEN":
        varname => 'ASSET_MANAGER_BEARER_TOKEN',
        value   => $asset_manager_bearer_token;
      "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
      "${title}-REDIS_HOST":
        varname => 'REDIS_HOST',
        value   => $redis_host;
      "${title}-REDIS_PORT":
        varname => 'REDIS_PORT',
        value   => $redis_port;
    }

    govuk::app { $app_name:
      app_type           => 'rack',
      port               => $port,
      enable_nginx_vhost => true,
    }
  }
}
