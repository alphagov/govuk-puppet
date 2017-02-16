# == Class: govuk::apps::panopticon
#
# Legacy app that holds content.
# Read more: https://github.com/alphagov/panopticon
#
# === Parameters
#
# [*port*]
#   The port that panopticon API is served on.
#   Default: 3003
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*mongodb_name*]
#   The Mongo database to be used.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::panopticon(
  $port = '3003',
  $errbit_api_key = undef,
  $mongodb_name = undef,
  $mongodb_nodes = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $publishing_api_bearer_token = undef,
  $secret_key_base = undef,
) {
  govuk::app { 'panopticon':
    ensure             => 'absent',
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }
}
