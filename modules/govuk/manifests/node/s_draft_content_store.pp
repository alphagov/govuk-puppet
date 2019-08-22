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
    'PLEK_SERVICE_SIGNON_URI': value => "https://signon.${app_domain}";
  }

  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    include ::hosts::default
    include ::hosts::backend_migration
    include icinga::client::check_pings
  }
}
