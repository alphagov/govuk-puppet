# == Class: govuk::node::s_email_campaign_api
#
# App server used for email-campaign app
#
class govuk::node::s_email_campaign_api inherits govuk::node::s_base {
  include nginx
  include govuk::node::s_ruby_app_server
}
