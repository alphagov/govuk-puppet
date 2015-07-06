# == Class: govuk::node::s_draft_frontend
#
# Draft Frontend machine definition. These machines run applications which
# serve draft (i.e. unpublished) content to users.
#
# Includes `govuk::node::s_frontend`, upon which this node definition is based.
#
# === Parameters
#
# [*draft_content_store_uri*]
#   URI of the content-store instance used to serve draft content.
#
# [*draft_static_uri*]
#   URI of the static application used when serving draft content.
#
class govuk::node::s_draft_frontend(
  $draft_content_store_uri,
  $draft_static_uri,
) inherits govuk::node::s_base {
  include govuk::node::s_frontend

  govuk::envvar { 'PLEK_HOSTNAME_PREFIX':
    value => 'draft-',
  }

  # FIXME Remove these once all apps deployed to these nodes support Plek
  # v1.11.0 or later
  # See: https://github.com/alphagov/plek/pull/34
  govuk::envvar { 'PLEK_SERVICE_CONTENT_STORE_URI':
    value => $draft_content_store_uri,
  }
  govuk::envvar { 'PLEK_SERVICE_STATIC_URI':
    value => $draft_static_uri,
  }
}
