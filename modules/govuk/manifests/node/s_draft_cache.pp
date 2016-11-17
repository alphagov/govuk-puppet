# == Class: govuk::node::s_draft_cache
#
# Configuration for a cache node that fronts draft content.
# Runs a varnish cache, the router and router-api.
#
# Includes `govuk::node::s_cache`.
#
class govuk::node::s_draft_cache() {
  include govuk::node::s_cache

  $app_domain = hiera('app_domain')

  govuk_envvar {
    'PLEK_HOSTNAME_PREFIX': value => 'draft-';
    'PLEK_SERVICE_ERRBIT_URI': value => "https://errbit.${app_domain}";
  }
}
