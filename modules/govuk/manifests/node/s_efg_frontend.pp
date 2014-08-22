# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_efg_frontend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server

  include govuk::apps::efg

  include nginx
}
