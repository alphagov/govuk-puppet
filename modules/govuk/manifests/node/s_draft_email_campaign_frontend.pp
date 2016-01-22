# == Class: govuk::node::s_draft_email_campaign_frontend
#
# Draft Email Campaign Frontend machine definition. These machines run
# applications which serve draft (i.e. unpublished) content to users.
#
# Includes `govuk::node::s_email_campaign_frontend`, upon which this node definition is based.
#
class govuk::node::s_draft_email_campaign_frontend() inherits govuk::node::s_base {
  include govuk::node::s_email_campaign_frontend

  govuk_envvar { 'PLEK_HOSTNAME_PREFIX':
    value => 'draft-',
  }
}
