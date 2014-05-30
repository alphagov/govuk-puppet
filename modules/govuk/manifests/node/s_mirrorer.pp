class govuk::node::s_mirrorer inherits govuk::node::s_base {
  include govuk::apps::govuk_crawler_worker
  include mirror
  include nginx
}
