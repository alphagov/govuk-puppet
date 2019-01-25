# == Class: govuk::apps::licencefinder
#
# An application for finding licences on gov.uk
#
# === Parameters
#
# [*port*]
#   The port that licence finder is served on.
#   Default: 3093
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
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*override_search_location*]
#   Alternative hostname to use for Plek("search") and Plek("rummager")
#
class govuk::apps::licencefinder(
  $port = '3014',
  $sentry_dsn = undef,
  $mongodb_nodes,
  $mongodb_name = 'licence_finder_production',
  $secret_key_base = undef,
  $publishing_api_bearer_token = undef,
  $override_search_location = undef,
) {

  $app_name = 'licencefinder'

  govuk::app { $app_name:
    app_type                 => 'rack',
    port                     => $port,
    sentry_dsn               => $sentry_dsn,
    health_check_path        => '/licence-finder/sectors',
    log_format_is_json       => true,
    asset_pipeline           => true,
    asset_pipeline_prefix    => 'licencefinder',
    repo_name                => 'licence-finder',
    override_search_location => $override_search_location,
  }

  if $::govuk_node_class !~ /^development$/ {
    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }
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

  if $::aws_migration {
    govuk::app::envvar { "${title}-ELASTICSEARCH_URI":
      app     => $app_name,
      varname => 'ELASTICSEARCH_URI',
      value   => 'http://rummager-elasticsearch:9200',
    }
  }
}
