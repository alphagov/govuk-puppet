# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_content_store inherits govuk::node::s_base {
  include govuk::node::s_app_server
  include nginx
  include nscd
  include router::gor

  nginx::config::vhost::default { 'default': }
}
