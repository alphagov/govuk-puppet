# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_logs_cdn inherits govuk::node::s_base {
  include govuk_cdnlogs
}
