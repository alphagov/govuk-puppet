# == Class: Govuk::Apps::Smokey
#
# Creates the environment variables required for Smokey
#
# === Parameters:
#
# [*rate_limit_token*]
#   Token to bypass our HTTP rate limiting
#
# [*smokey_signon_email*]
#   Email address to login to Signon as a smoke test user
#
# [*smokey_signon_password*]
#   Password for $smokey_signon_email
#
# [*smokey_bearer_token*]
#   Bearer token for internal HTTP requests made by Smokey
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
class govuk::apps::smokey (
  $rate_limit_token = undef,
  $smokey_signon_email = undef,
  $smokey_signon_password = undef,
  $smokey_bearer_token = undef,
  $sentry_dsn = undef,
){
  $app = 'smokey'
  $app_domain = hiera('app_domain')

  file { ["/etc/govuk/${app}", "/etc/govuk/${app}/env.d"]:
    ensure => 'directory',
  }

  Govuk::App::Envvar {
    app            => $app,
    notify_service => false,
    require        => File["/etc/govuk/${app}/env.d"],
  }

  govuk::app::envvar {
    'BEARER_TOKEN':             value => $smokey_bearer_token;
    'RATE_LIMIT_TOKEN':         value => $rate_limit_token;
    'SIGNON_EMAIL':             value => $smokey_signon_email;
    'SIGNON_PASSWORD':          value => $smokey_signon_password;
    'DBUS_SESSION_BUS_ADDRESS': value => 'disabled:';
    'SENTRY_DSN':               value => $sentry_dsn;
    'GOVUK_STATSD_PREFIX':      value => "govuk.app.smokey.${::hostname}";
  }

  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    govuk::app::envvar {
      'PLEK_SERVICE_ASSET_MANAGER_URI': value => "https://asset-manager.${app_domain}";
    }
  }
}
