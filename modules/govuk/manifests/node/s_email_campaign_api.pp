# == Class: govuk::node::s_email_campaign_api
#
# App server used for email-campaign app
#
class govuk::node::s_email_campaign_api inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server

  include govuk::apps::email_campaign_api

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }
}
