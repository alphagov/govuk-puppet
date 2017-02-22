# == Class: icinga::config::smokey
#
# Set up smoke tests to run from within Icinga
#
# === Parameters
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
class icinga::config::smokey (
  $http_username = 'UNSET',
  $http_password = 'UNSET',
  $rate_limit_token = 'UNSET',
  $smokey_signon_email = 'UNSET',
  $smokey_signon_password = 'UNSET',
  $smokey_bearer_token = 'UNSET',
) {
  $smokey_vars = {
    'AUTH_USERNAME'    => $http_username,
    'AUTH_PASSWORD'    => $http_password,
    'SIGNON_EMAIL'     => $smokey_signon_email,
    'SIGNON_PASSWORD'  => $smokey_signon_password,
    'BEARER_TOKEN'     => $smokey_bearer_token,
    'RATE_LIMIT_TOKEN' => $rate_limit_token,
  }

  file { '/etc/smokey.sh':
    content => template('icinga/etc/smokey.sh.erb'),
    mode    => '0400',
  }

  file { '/etc/icinga/conf.d/check_smokey.cfg':
    source => 'puppet:///modules/icinga/etc/icinga/conf.d/check_smokey.cfg',
  }
}
