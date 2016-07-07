# == Class: govuk::node::s_licensify_lb
#
# Sets up a loadbalancer machine for licensing
#
# === Parameters
#
# [*backend_app_servers*]
#   An array of machines where the backend app lives
#
# [*frontend_app_servers*]
#   An array of machines where the frontend app lives
#
# [*enable_feed_console*]
#   Boolean, whether the licensify-feed app should be loadbalanced
#
class govuk::node::s_licensify_lb (
  $backend_app_servers,
  $frontend_app_servers,
  $enable_feed_console = false,
){
  include govuk::node::s_base

  include loadbalancer

  loadbalancer::balance {
    # Licensify frontend
    'licensify':
      https_redirect => false,
      servers        => $frontend_app_servers,
      internal_only  => true;

    # Licensify upload pdf public endpoint
    'uploadlicence':
      internal_only => true,
      servers       => $frontend_app_servers;

    # Licensify admin interface
    'licensify-admin':
      internal_only => true,
      servers       => $backend_app_servers;

    # Licensing web forms
    'licensing-web-forms':
      https_redirect => true,
      servers        => $frontend_app_servers,
      internal_only  => true;

  }
  if ($enable_feed_console) {
    loadbalancer::balance {
      # Licensify feed frontend
      'licensify-feed':
        internal_only => true,
        servers       => $backend_app_servers;
    }
  }
}
