class govuk::node::s_licensify_lb {
  include govuk::node::s_base

  include loadbalancer

  $licensify_frontend_servers = extlookup('lb_nodes_licensify_frontend')
  $licensify_backend_servers = extlookup('lb_nodes_licensify_backend')
  $enable_feed_console = str2bool(extlookup('govuk_enable_licensify_feed_console','no'))
  $enable_licensing_api = str2bool(extlookup('govuk_enable_licensing_api','no'))

  loadbalancer::balance {
    # Licensify frontend
    'licensify':
      https_only    => false,
      servers       => $licensify_frontend_servers,
      internal_only => true;

    # Licensify upload pdf public endpoint
    'uploadlicence':
      internal_only => true,
      servers       => $licensify_frontend_servers;

    # Licensify admin interface
    'licensify-admin':
      internal_only => true,
      servers       => $licensify_backend_servers;

  }
  if ($enable_feed_console) {
    loadbalancer::balance {
      # Licensify feed frontend
      'licensify-feed':
        internal_only => true,
        servers       => $licensify_backend_servers;
    }
  }
  if ($enable_licensing_api) {
    loadbalancer::balance {
      # Licensing API
      'licensing-api':
        internal_only => true,
        servers       => $licensify_backend_servers;
    }
  }
}
