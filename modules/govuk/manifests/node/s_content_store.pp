# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_content_store inherits govuk::node::s_base {
  include govuk::node::s_app_server
  include govuk_aws_xray_daemon
  include nginx
  include nscd
  include router::gor

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    include ::hosts::default
    include ::hosts::backend_migration
  }
}
