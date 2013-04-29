class govuk::node::s_licensify_lb {
  include govuk::node::s_base

  include loadbalancer

  $licensify_frontend_servers = ["licensify-frontend-1", "licensify-frontend-2"]
  $licensify_backend_servers = ["licensify-backend-1", "licensify-backend-2"]
  $enable_feed_console = str2bool(extlookup('govuk_enable_licensify_feed_console','no'))

  # FIXME: Revert this hack after Licensify maintenance (30/04/13)
  $licensify_maintenance_mode = str2bool(extlookup('licensify_maintenance_mode','no'))
  if $licensify_maintenance_mode {
    $licensify_frontend_maintenance_file = 'licensify_frontend_maintenance.html'
    $licensify_backend_maintenance_file  = 'licensify_backend_maintenance.html'
  } else {
    $licensify_frontend_maintenance_file = undef
    $licensify_backend_maintenance_file  = undef
  }

  file {
    '/usr/share/nginx/html/licensify_frontend_maintenance.html':
        ensure => present,
        source => 'puppet:///modules/govuk/node/s_licensify_lb/licensify_frontend_maintenance.html';
    '/usr/share/nginx/html/licensify_backend_maintenance.html':
        ensure => present,
        source => 'puppet:///modules/govuk/node/s_licensify_lb/licensify_backend_maintenance.html';
  }

  loadbalancer::balance {
    # Licensify frontend
    'licensify':
      maintenance   => $licensify_frontend_maintenance_file,
      servers       => $licensify_frontend_servers,
      internal_only => true;

    # Licensify upload pdf public endpoint
    'uploadlicence':
      maintenance   => $licensify_frontend_maintenance_file,
      https_only    => true,
      internal_only => true,
      servers       => $licensify_frontend_servers;

    # Licensify admin interface
    'licensify-admin':
      maintenance   => $licensify_backend_maintenance_file,
      https_only    => true,
      internal_only => true,
      servers       => $licensify_backend_servers;
  }

  if ($enable_feed_console) {
    loadbalancer::balance {
      # Licensify feed frontend
      'licensify-feed':
        https_only    => true,
        internal_only => true,
        servers       => $licensify_backend_servers;
    }
  }
}
