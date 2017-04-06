# == Class: govuk::apps::publishing_api
#
# An application to manage releases on GOV.UK
#
# === Parameters
#
# [*port*]
#   The port that the release app is served on.
#   Default: 3036
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#
# [*db_password*]
#   The password for the database.
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*github_username*]
#   The username to use when accessing the Github API.
#
# [*github_access_token*]
#   The access token to use when accessing the Github API.
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
class govuk::apps::release(
  $port = '3036',
  $errbit_api_key = '',
  $secret_key_base = undef,
  $db_hostname = undef,
  $db_username = undef,
  $db_password = undef,
  $db_name = 'release_production',
  $github_username = undef,
  $github_access_token = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
) {
  $app_name = 'release'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-GITHUB_USERNAME":
      varname => 'GITHUB_USERNAME',
      value   => $github_username;
    "${title}-GITHUB_ACCESS_TOKEN":
      varname => 'GITHUB_ACCESS_TOKEN',
      value   => $github_access_token;
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  if $::govuk_node_class !~ /^(development|training)$/ {
    govuk::app::envvar::database_url { $app_name:
      type     => 'mysql2',
      username => $db_username,
      password => $db_password,
      host     => $db_hostname,
      database => $db_name,
    }
  }

}
