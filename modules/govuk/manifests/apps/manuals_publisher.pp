# == Class: govuk::apps::manuals_publisher
#
# Publishing App for manuals.
#
# === Parameters
#
# [*port*]
#   The port that Manuals Publisher is served on.
#   Default: 3064
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#   Default: undef
#
# [*email_alert_api_bearer_token*]
#   The bearer token to use when communicating with Email Alert API.
#   Default: undef
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*errbit_api_key*]
#   Errbit API key for sending errors.
#   Default: undef
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*mongodb_name*]
#   The mongo database to be used. Overriden in development
#   to be 'manuals_publisher_development'.
#
# [*oauth_id*]
#   Sets the OAuth ID for using GDS-SSO
#   Default: undef
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key for using GDS-SSO
#   Default: undef
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*redis_host*]
#   Redis host for sidekiq.
#
# [*redis_port*]
#   Redis port for sidekiq.
#   Default: 6379
#
class govuk::apps::manuals_publisher(
  $port = 3205,
  $asset_manager_bearer_token = undef,
  $email_alert_api_bearer_token = undef,
  $enable_procfile_worker = true,
  $errbit_api_key = undef,
  $mongodb_nodes,
  $mongodb_name,
  $oauth_id = undef,
  $oauth_secret = undef,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $secret_token = undef,
) {
  $app_name = 'manuals-publisher'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    nginx_extra_config => 'client_max_body_size 500m;',
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::procfile::worker {'manuals-publisher':
    enable_service => $enable_procfile_worker,
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  # FIXME: This templated list of mongodb nodes is a temporary measure to allow
  # us to run manuals publisher on earlier ruby versions as ruby 2.1 cannot
  # parse the comma delimited MONGODB_URI var.
  # Either MONGODB_URI or MONGODB_NODES should be removed from this module once
  # we have resolved ruby version issues.
  # Please talk to Steve Laing for more information.
  $mongodb_nodes_template = '<%= @mongodb_nodes.map { |node| "- #{node}:27017" }.join("\n") %>'
  $mongodb_nodes_string = inline_template($mongodb_nodes_template)

  govuk::app::envvar {
    "${title}-ASSET_MANAGER_BEARER_TOKEN":
      varname => 'ASSET_MANAGER_BEARER_TOKEN',
      value   => $asset_manager_bearer_token;
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
      varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
      value   => $email_alert_api_bearer_token;
    "${title}-MONGODB_NODES":
      varname => 'MONGODB_NODES',
      value   => $mongodb_nodes_string;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
  }

  if $secret_token != undef {
    govuk::app::envvar { "${title}-SECRET_TOKEN":
      varname => 'SECRET_TOKEN',
      value   => $secret_token,
    }
  }
}
