# == Class: govuk::apps::transition
#
# Managing mappings (eg redirects) for sites moving to GOV.UK.
#
# === Parameters
#
# [*port*]
#   The port that transition is served on.
#   Default: 3044
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*oauth_id*]
#   The Signon OAuth identifier for this app
#
# [*oauth_secret*]
#   The Signon OAuth secret for this app
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
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*basic_auth_username*]
#   The username to use for Basic Auth
#
# [*basic_auth_password*]
#   The password to use for Basic Auth
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*ga_auth_provider_x509_cert_url*]
# [*ga_auth_uri*]
# [*ga_client_email*]
# [*ga_client_id*]
# [*ga_client_x509_cert_url*]
# [*ga_key_p12_b64*]
# [*ga_token_uri*]
#   Authentication credentials for Google Analytics
#
class govuk::apps::transition(
  $port = '3044',
  $enable_procfile_worker = true,
  $oauth_id = undef,
  $oauth_secret = undef,
  $redis_host = undef,
  $redis_port = undef,
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $basic_auth_username = undef,
  $basic_auth_password = undef,
  $errbit_api_key = undef,
  $ga_auth_provider_x509_cert_url = undef,
  $ga_auth_uri = undef,
  $ga_client_email = undef,
  $ga_client_id = undef,
  $ga_client_x509_cert_url = undef,
  $ga_key_p12_b64 = undef,
  $ga_token_uri = undef,
) {
  $app_name = 'transition'

  include govuk_postgresql::client
  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    deny_framing       => true,
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

  if $secret_key_base {
    govuk::app::envvar {
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
      "${title}-BASIC_AUTH_USERNAME":
        varname => 'BASIC_AUTH_USERNAME',
        value   => $basic_auth_username;
      "${title}-BASIC_AUTH_PASSWORD":
        varname => 'BASIC_AUTH_PASSWORD',
        value   => $basic_auth_password;
      "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
      "${title}-GA_AUTH_PROVIDER_X509_CERT_URL":
        varname => 'GA_AUTH_PROVIDER_X509_CERT_URL',
        value   => $ga_auth_provider_x509_cert_url;
      "${title}-GA_AUTH_URI":
        varname => 'GA_AUTH_URI',
        value   => $ga_auth_uri;
      "${title}-GA_CLIENT_EMAIL":
        varname => 'GA_CLIENT_EMAIL',
        value   => $ga_client_email;
      "${title}-GA_CLIENT_ID":
        varname => 'GA_CLIENT_ID',
        value   => $ga_client_id;
      "${title}-GA_CLIENT_X509_CERT_URL":
        varname => 'GA_CLIENT_X509_CERT_URL',
        value   => $ga_client_x509_cert_url;
      "${title}-GA_KEY_P12_B64":
        varname => 'GA_KEY_P12_B64',
        value   => $ga_key_p12_b64;
      "${title}-GA_TOKEN_URI":
        varname => 'GA_TOKEN_URI',
        value   => $ga_token_uri;
    }
  }
}
