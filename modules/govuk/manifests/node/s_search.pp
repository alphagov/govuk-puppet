# == Class govuk::node::s_search
#
# Machines for running the search applications (initially rummager) in the api vDC
#
class govuk::node::s_search inherits govuk::node::s_base {
  include govuk::node::s_app_server

  include govuk_aws_xray_daemon

  include govuk_search::gor

  include govuk_search::monitoring

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  # Data sync for managed elasticsearch
  if $::aws_migration {
    include govuk_env_sync
  }

  # Set Plek for AWS to Carrenza communication
  if ( ( $::aws_migration == 'search' ) and ($::aws_environment == 'staging') ) or ( ($::aws_migration == 'search' ) and ($::aws_environment == 'production') ) {
    $app_domain = hiera('app_domain')

    govuk_envvar {
      'PLEK_SERVICE_EMAIL_ALERT_API_URI': value  => "https://email-alert-api.${app_domain}";
      'PLEK_SERVICE_PUBLISHING_API_URI': value  => "https://publishing-api.${app_domain}";
    }
  }
}
