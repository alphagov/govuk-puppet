# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_content_store inherits govuk::node::s_base {
  include govuk::node::s_app_server
  include nginx
  include nscd
  include router::gor

  # In Staging environment, the content-store app will create its own default
  # vhost
  if ($::aws_environment != 'staging' and $::aws_environment != 'production') {
    # If we miss all the apps, throw a 500 to be caught by the cache nginx
    nginx::config::vhost::default { 'default': }
  }

  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    include ::hosts::default
    include ::hosts::backend_migration
    include icinga::client::check_pings
  }
}
