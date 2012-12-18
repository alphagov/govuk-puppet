class govuk::node::s_licensify_lb {
  include govuk::node::s_base

  include haproxy
  include loadbalancer::cron

  $licensify_frontend_servers = {
    "licensify-frontend-1" => "10.5.0.2",
    "licensify-frontend-2" => "10.5.0.3",
  }
  $licensify_backend_servers = {
    "licensify-backend-1" => "10.5.0.4",
    "licensify-backend-2" => "10.5.0.5",
  }

# Licensify Frontend Load Balancers
  haproxy::balance_http_and_https {
    'licensify':
      servers             => $licensify_frontend_servers,
      internal_only       => true,
      health_check_port   => 15500,
      https_listen_port   => 8490,
      http_listen_port    => 8590,
      health_check_method => 'GET'
  }
# Licensify upload pdf public endpoint
  haproxy::balance_https {
    'uploadlicence':
      servers             => $licensify_frontend_servers,
      internal_only       => true,
      health_check_port   => 15500,  #The health check port is the same as licensify, since it is the same app listening on a different vhost
      listen_port         => 8491,
      health_check_method => 'GET'
  }

  haproxy::balance_https {'licensify-admin':
    servers             => $licensify_backend_servers,
    health_check_port   => 16000,
    listen_port         => 8492,
    health_check_method => 'GET',
    internal_only       => true,
  }
}
