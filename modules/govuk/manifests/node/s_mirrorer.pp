class govuk::node::s_mirrorer inherits govuk::node::s_base {
  include govuk::apps::govuk_crawler_worker
  include govuk_crawler
  # FIXME: Remove 'mirror' module once 'govuk_crawler' is working
  # satisfactorily
  include mirror
  include nginx
}
