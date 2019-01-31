# == Class: govuk::node::s_content_store
#
# Configures a machine to install the content-store app and its necessary
# dependencies
# === Parameters
#
# [*skip_default_nginx_config_creation*]
#  Specifies whether to SKIP the creation of the default nginx config
#  at this level of the class. The config will have to be created in the
#  `govuk::apps::content_store` class
#  Default: false
#
class govuk::node::s_content_store (
  $skip_default_nginx_config_creation = false,
) inherits govuk::node::s_base {
  include govuk::node::s_app_server
  include govuk_aws_xray_daemon
  include nginx
  include nscd
  include router::gor

  # In Staging environment, the content-store app will create its own default
  # vhost
  if ($::aws_environment != 'staging') or
      ($::aws_environment == 'staging' and $skip_default_nginx_config_creation == false){
    # If we miss all the apps, throw a 500 to be caught by the cache nginx
    nginx::config::vhost::default { 'default': }
  }

  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    include ::hosts::default
    include ::hosts::backend_migration
    include icinga::client::check_pings
  }
}
