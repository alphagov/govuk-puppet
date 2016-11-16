# == Class: govuk::node::s_draft_content_store
#
# Draft content store machine definition. These machines run an instance of the
# content-store application which serves draft (i.e. unpublished) content to
# users.
#
# Includes `govuk::node::s_content_store`, upon which this node definition is based.
#
class govuk::node::s_draft_content_store() inherits govuk::node::s_base {
  include govuk::node::s_content_store

  $app_domain = hiera('app_domain')

  govuk_envvar {
    'PLEK_HOSTNAME_PREFIX': value => 'draft-';
    'PLEK_SERVICE_ERRBIT_URI': value => "https://errbit.${app_domain}";
  }
}

