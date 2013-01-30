class govuk::node::s_licensify_lb {
  include govuk::node::s_base

  include loadbalancer

  $licensify_frontend_servers = ["licensify-frontend-1", "licensify-frontend-2"]
  $licensify_backend_servers = ["licensify-backend-1", "licensify-backend-2"]

  loadbalancer::balance {
    # Licensify frontend
    'licensify':
      servers       => $licensify_frontend_servers,
      internal_only => true;

    # Licensify upload pdf public endpoint
    'uploadlicence':
      https_only    => true,
      internal_only => true,
      servers       => $licensify_frontend_servers;

    # Licensify admin interface
    'licensify-admin':
      https_only    => true,
      internal_only => true,
      servers       => $licensify_backend_servers;
  }
}
