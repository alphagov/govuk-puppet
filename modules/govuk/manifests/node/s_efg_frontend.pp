class govuk::node::s_efg_frontend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server

  include govuk::apps::efg

  include nginx
}
