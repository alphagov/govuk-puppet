# == Class: govuk::apps::kibana
#
# Set up the Kibana application behind Signon
#
# === Parameters
#
# [*elasticsearch_host*]
#   Which logs-elasticsearch host Kibana should connect to, must
#   be a single host: https://github.com/elasticsearch/kibana/issues/214
#
# [*port*]
#   Port that the Kibana wrapper listens on
#
# [*secret_key*]
#   A secret key for Rack's session cookies
#
# [*signon_client_id*]
#   A client ID for GOV.UK's Signon
#
# [*signon_client_secret*]
#   The secret which matches signon_client_id
#
# [*signon_root*]
#   The HTTP location of Signon
#
class govuk::apps::kibana (
  $elasticsearch_host = 'logs-elasticsearch-1.management',
  $port = 3202,
  $secret_key = undef,
  $signon_client_id = undef,
  $signon_client_secret = undef,
  $signon_root = undef,
) {
  $app_name = 'kibana'

  govuk::app { $app_name:
    app_type => 'rack',
    port     => $port,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    "${title}-ES_HOST":
      varname => 'ES_HOST',
      value   => $elasticsearch_host;
    "${title}-SECRET_KEY":
      varname => 'SECRET_KEY',
      value   => $secret_key;
    "${title}-SIGNON_CLIENT_ID":
      varname => 'SIGNON_CLIENT_ID',
      value   => $signon_client_id;
    "${title}-SIGNON_CLIENT_SECRET":
      varname => 'SIGNON_CLIENT_SECRET',
      value   => $signon_client_secret;
    "${title}-SIGNON_ROOT":
      varname => 'SIGNON_ROOT',
      value   => $signon_root;
  }

}
