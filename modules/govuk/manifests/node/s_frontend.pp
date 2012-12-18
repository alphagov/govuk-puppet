class govuk::node::s_frontend inherits govuk::node::s_base {

  include govuk::node::s_ruby_app_server

  include govuk::apps::datainsight_frontend
  include govuk::apps::tariff
  include govuk::apps::calendars
  include govuk::apps::canary_frontend
  include govuk::apps::smartanswers
  include govuk::apps::feedback
  include govuk::apps::designprinciples
  include govuk::apps::licencefinder
  include govuk::apps::publicapi #FIXME to be removed when we ditch ec2 -- ppotter 2012-10-12
  include govuk::apps::frontend
  include govuk::apps::static
  include govuk::apps::businesssupportfinder
  case $::govuk_provider {
    'sky':   {}
    default: {
      include govuk::apps::efg
      include govuk::apps::travel_advice_frontend # Only add to EC2 (i.e. preview) for now.
    }
  }

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }
}
