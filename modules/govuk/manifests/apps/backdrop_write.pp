# == Class: govuk::apps::backdrop_write
#
# backdrop_write is the write component of the Performance Platform
# API.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker. Typically sued to disable the worker
#   on the dev VM.
#
# [*signon_api_user_token*]
#   An API token to allow backdrop-write to communicate with the performanceplatform-admin
#   app via Signon
#
# [*stagecraft_collection_endpoint_token*]
#   Token to allow backdrop-write to modify Stagecraft
#
# [*transformer_rabbitmq_password*]
#   Password to access the backdrop_write RabbitMQ queue
#
# [*transformer_stagecraft_oauth_token*]
#   Token to allow transformers to access Stagecraft
#
class govuk::apps::backdrop_write (
  $enabled = true,
  $enable_procfile_worker = true,
  $signon_api_user_token = undef,
  $stagecraft_collection_endpoint_token = undef,
  $transformer_rabbitmq_password = undef,
  $transformer_stagecraft_oauth_token = undef,
) {
  if $enabled {
    $app_name = 'backdrop-write'
    $port = '3102'

    govuk::app { $app_name:
      app_type           => 'bare',
      port               => $port,
      command            => "./venv/bin/gunicorn backdrop.write.api:app --bind 127.0.0.1:${port} --workers 4 --timeout 60",
      vhost_ssl_only     => true,
      health_check_path  => '/_status',
      nginx_extra_config => 'client_max_body_size 50m;',
      read_timeout       => 60,
      log_format_is_json => true,
    }

    govuk::procfile::worker { 'backdrop-transformer':
      setenv_as      => $app_name,
      enable_service => $enable_procfile_worker,
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar {
      "${title}-SIGNON_API_USER_TOKEN":
        varname => 'SIGNON_API_USER_TOKEN',
        value   => $signon_api_user_token;
      "${title}-STAGECRAFT_COLLECTION_ENDPOINT_TOKEN":
        varname => 'STAGECRAFT_COLLECTION_ENDPOINT_TOKEN',
        value   => $stagecraft_collection_endpoint_token;
      "${title}-TRANSFORMER_RABBITMQ_PASSWORD":
        varname => 'TRANSFORMER_RABBITMQ_PASSWORD',
        value   => $transformer_rabbitmq_password;
      "${title}-TRANSFORMER_STAGECRAFT_OAUTH_TOKEN":
        varname => 'TRANSFORMER_STAGECRAFT_OAUTH_TOKEN',
        value   => $transformer_stagecraft_oauth_token;
    }

  }
}
