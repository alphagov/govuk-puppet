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

  govuk_envvar {
    'PLEK_HOSTNAME_PREFIX': value => 'draft-';
    'PLEK_SERVICE_ERRBIT_URI': value => "https://errbit.${app_domain}";
  }
}
