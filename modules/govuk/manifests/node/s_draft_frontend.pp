# == Class: govuk::node::s_draft_frontend
#
# Draft Frontend machine definition. These machines run applications which
# serve draft (i.e. unpublished) content to users.
#
# Includes `govuk::node::s_frontend`, upon which this node definition is based.
#
class govuk::node::s_draft_frontend() inherits govuk::node::s_base {
  include govuk::node::s_frontend

  $app_domain = hiera('app_domain')

  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    $app_domain_internal      = hiera('app_domain_internal')
    $plek_uri_domain_override = $app_domain
  } elsif $::aws_environment == 'integration' {
    $app_domain_internal      = hiera('app_domain_internal')
    $plek_uri_domain_override = $app_domain_internal
  } else {
    $app_domain_internal      = $app_domain
    $plek_uri_domain_override = $app_domain
  }

  govuk_envvar {
    'PLEK_HOSTNAME_PREFIX': value => 'draft-';
    'PLEK_SERVICE_IMMINENCE_URI': value => "https://imminence.${app_domain}";
    'PLEK_SERVICE_LOCAL_LINKS_MANAGER_URI': value => "https://local-links-manager.${app_domain}";
    'PLEK_SERVICE_MAPIT_URI': value => "https://mapit.${app_domain_internal}";
    'PLEK_SERVICE_SEARCH_URI': value => "https://search.${app_domain_internal}";
  }
}
