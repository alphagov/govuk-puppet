# == Class: govuk::node::s_draft_cache
#
# Configuration for a cache node that fronts draft content.
# Runs a varnish cache, the router and router-api.
#
# Includes `govuk::node::s_cache`.
#
class govuk::node::s_draft_cache(
  $enable_authenticating_proxy = true,
) {
  class { 'govuk::node::s_cache':
    enable_authenticating_proxy => $enable_authenticating_proxy,
  }

  $app_domain = hiera('app_domain')

  govuk_envvar {
    'PLEK_HOSTNAME_PREFIX': value => 'draft-';
  }
}
