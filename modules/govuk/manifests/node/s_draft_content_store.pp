# == Class: govuk::node::s_draft_content_store
#
# Draft content store machine definition. These machines run an instance of the
# content-store application which serves draft (i.e. unpublished) content to
# users.
#
# Includes `govuk::node::s_content_store`, upon which this node definition is based.
#
# === Parameters
#
# [*draft_router_api_uri*]
#   URI of the router-api application used to register routes for draft
#   content.
#
class govuk::node::s_draft_content_store(
  $draft_router_api_uri,
) inherits govuk::node::s_base {
  include govuk::node::s_content_store

  govuk::envvar { 'PLEK_HOSTNAME_PREFIX':
    value => 'draft-',
  }

  # FIXME Remove this once content-store release_140 is deployed to Production
  # See: https://github.com/alphagov/plek/pull/34
  govuk::envvar { 'PLEK_SERVICE_ROUTER_API_URI':
    value => $draft_router_api_uri,
  }
}

