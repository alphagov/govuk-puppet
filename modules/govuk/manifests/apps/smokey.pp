# == Class: Govuk::Apps::Smokey
#
# Creates the environment variables required for Smokey
#
# === Parameters:
#
# [*http_username*]
#   Basic auth username
#
# [*http_password*]
#   Password for $http_username
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
#   Bearer token for something
#
class govuk::apps::smokey (
  $http_username = undef,
  $http_password = undef,
  $rate_limit_token = undef,
  $smokey_signon_email = undef,
  $smokey_signon_password = undef,
  $smokey_bearer_token = undef,
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
    'AUTH_PASSWORD':    value => $http_password;
    'AUTH_USERNAME':    value => $http_username;
    'BEARER_TOKEN':     value => $smokey_bearer_token;
    'RATE_LIMIT_TOKEN': value => $rate_limit_token;
    'SIGNON_EMAIL':     value => $smokey_signon_email;
    'SIGNON_PASSWORD':  value => $smokey_signon_password;
  }

  if $::aws_migration {
    govuk::app::envvar {
      'PLEK_SERVICE_ASSET_MANAGER_URI': value => "https://asset-manager.${app_domain}";
    }
  }
}
