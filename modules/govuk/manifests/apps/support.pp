# == Class: govuk::apps::support
#
# Provides forms that create Zendesk tickets from requests
# coming from government agencies.
#
# === Parameters
#
# [*emergency_contact_details*]
#   Emergency phone numbers and other contact details presented in this app.
#
# [*enable_procfile_worker*]
#   Enables the sidekiq background worker.
#   Default: true
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3093
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*zendesk_anonymous_ticket_email*]
#   Email address used for anonymous zendesk tickets.
#
# [*zendesk_client_password*]
#   Password for connection to GDS zendesk client.
#
# [*zendesk_client_username*]
#   Username for connection to GDS zendesk client.
#
class govuk::apps::support(
  $emergency_contact_details = undef,
  $errbit_api_key = undef,
  $enable_procfile_worker = true,
  $oauth_id = undef,
  $oauth_secret = undef,
  $port = '3031',
  $redis_host = undef,
  $redis_port = undef,
  $secret_key_base = undef,
  $zendesk_anonymous_ticket_email = undef,
  $zendesk_client_password = undef,
  $zendesk_client_username = undef,
) {

  $app_name = 'support'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    nginx_extra_config => '
      location /_status {
        allow   127.0.0.0/8;
        deny    all;
      }

      proxy_set_header X-Sendfile-Type X-Accel-Redirect;
      proxy_set_header X-Accel-Mapping /data/uploads/support-api/csvs/=/csvs/;

      location /csvs/ {
        internal;
        root /data/uploads/support-api;
      }',
    asset_pipeline     => true,
  }

  govuk::procfile::worker { $app_name:
    enable_service => $enable_procfile_worker,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  $emergency_contact_details_json = inline_template(
    '<%= @emergency_contact_details.to_json unless @emergency_contact_details.nil? %>')

  govuk::app::envvar {
    "${title}-EMERGENCY_CONTACT_DETAILS":
      varname => 'EMERGENCY_CONTACT_DETAILS',
      value   => $emergency_contact_details_json;
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-ZENDESK_ANONYMOUS_TICKET_EMAIL":
      varname => 'ZENDESK_ANONYMOUS_TICKET_EMAIL',
      value   => $zendesk_anonymous_ticket_email;
    "${title}-ZENDESK_CLIENT_PASSWORD":
      varname => 'ZENDESK_CLIENT_PASSWORD',
      value   => $zendesk_client_password;
    "${title}-ZENDESK_CLIENT_USERNAME":
      varname => 'ZENDESK_CLIENT_USERNAME',
      value   => $zendesk_client_username;
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }
}
