# == Class: govuk::node::s_draft_cache
#
# Configuration for a cache node that fronts draft content.
# Runs a varnish cache, the router and router-api.
#
# Includes `govuk::node::s_cache`.
#
# === Parameters
#
# [*router_mongodb_name*]
#   Name of the MongoDB database to be used by the Router application.
#
class govuk::node::s_draft_cache(
  $router_mongodb_name,
) {
  include govuk::node::s_cache

  include govuk::apps::router_api

  govuk::app::envvar { "${title}-ROUTER_MONGO_DB":
    app     => 'router',
    value   => $router_mongodb_name,
    varname => 'ROUTER_MONGO_DB',
  }
}
