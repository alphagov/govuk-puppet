class govuk::node::efg_frontend_server inherits govuk::node::base {
  include govuk::node::ruby_app_server

  include govuk::apps::efg

  include nginx
}
