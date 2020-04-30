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
  $app_domain_internal = hiera('app_domain_internal')

  govuk_envvar {
    'PLEK_HOSTNAME_PREFIX': value => 'draft-';
    'PLEK_SERVICE_SIGNON_URI': value => "https://signon.${app_domain}";
    'PLEK_SERVICE_FEEDBACK_URI': value => "https://feedback.${app_domain_internal}";
    'PLEK_SERVICE_INFO_FRONTEND_URI': value => "https://info-frontend.${app_domain_internal}";
  }
}
