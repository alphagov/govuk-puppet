class govuk_node::efg_frontend_server inherits govuk_node::base {
  include govuk_node::ruby_app_server

  include govuk::apps::efg

  include nginx
}
