class govuk_node::frontend_server inherits govuk_node::base {

  include govuk_node::ruby_app_server

  include govuk::apps::planner
  include govuk::apps::datainsight_frontend
  include govuk::apps::tariff
  include govuk::apps::efg
  include govuk::apps::calendars
  include govuk::apps::smartanswers
  include govuk::apps::feedback
  include govuk::apps::designprinciples
  include govuk::apps::licencefinder
  include govuk::apps::publicapi
  include govuk::apps::frontend
  include govuk::apps::search
  include govuk::apps::static

  include nginx
}
