# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_mirrorer inherits govuk::node::s_base {
  include govuk::apps::govuk_crawler_worker
  include govuk_crawler
  include nginx
}
