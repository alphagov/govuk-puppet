# == Class: govuk::apps::licencefinder
#
# An application for finding licences on gov.uk
#
# === Parameters
#
# [*port*]
#   The port that licence finder is served on.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*mongodb_nodes*]
#   An array of MongoDB instance hostnames
#
# [*mongodb_name*]
#   The name of the MongoDB database to use
#
# [*elasticsearch_uri*]
#   The URL of the elasticsearch instance
#   Default: http://elasticsearch6
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::licencefinder(
  $port,
  $sentry_dsn = undef,
  $mongodb_nodes,
  $mongodb_name = 'licence_finder_production',
  $elasticsearch_uri = 'http://elasticsearch6',
  $secret_key_base = undef,
  $publishing_api_bearer_token = undef,
) {

  $app_name = 'licencefinder'

  govuk::app { $app_name:
    app_type                => 'rack',
    port                    => $port,
    nginx_extra_config      => template('licencefinder/nginx_extra'),
    sentry_dsn              => $sentry_dsn,
    health_check_path       => '/licence-finder/sectors',
    log_format_is_json      => true,
    asset_pipeline          => true,
    asset_pipeline_prefixes => ['assets/licencefinder'],
    repo_name               => 'licence-finder',
  }

  nginx::conf { 'rate-limiting':
    content => "limit_req_zone \$binary_remote_addr zone=licencefinder:1m rate=1r/s;\n",
  }

  nginx::conf { 'real-ip-params':
    content => "
      real_ip_header True-Client-Ip;
      real_ip_recursive on;
      set_real_ip_from 0.0.0.0/0;
    ",
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
  }

  if $secret_key_base {
    govuk::app::envvar {
      "${title}-SECRET_KEY_BASE":
        app     => $app_name,
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    }
  }

  govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
    app     => $app_name,
    varname => 'PUBLISHING_API_BEARER_TOKEN',
    value   => $publishing_api_bearer_token,
  }

  if $::aws_migration  {
    govuk::app::envvar { "${title}-ELASTICSEARCH_URI":
      app     => $app_name,
      varname => 'ELASTICSEARCH_URI',
      value   => $elasticsearch_uri,
    }
  }
}
