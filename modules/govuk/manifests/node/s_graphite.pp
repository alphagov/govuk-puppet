class govuk::node::s_graphite inherits govuk::node::s_base {
  include graphite
  include collectd::server
}
