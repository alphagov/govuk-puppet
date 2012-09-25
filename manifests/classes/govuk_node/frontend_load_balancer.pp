class govuk_node::frontend_load_balancer {
  include govuk_node::base

  include haproxy

  $govuk_frontend_servers = {
    "frontend-1" => "10.2.0.2",
    "frontend-2" => "10.2.0.3",
    "frontend-3" => "10.2.0.4",
  }

  $whitehall_frontend_servers = {
    "whitehall-frontend-1" => "10.2.0.5",
    "whitehall-frontend-2" => "10.2.0.6",
  }

  $efg_frontend_servers = {
    "efg-frontend-1" => "10.4.0.2",
  }

  $licensify_frontend_servers = {
    "licensify-frontend-1" => "10.5.0.2",
    "licensify-frontend-2" => "10.5.0.3",
  }

  # Frontend Load Balancers
  haproxy::balance_http_and_https {
    'planner':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9507,
      https_listen_port => 8407,
      http_listen_port  => 8507;
    'datainsight-frontend':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9527,
      https_listen_port => 8427,
      http_listen_port  => 8527;
    'tariff':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9517,
      https_listen_port => 8417,
      http_listen_port  => 8517;
    'calendars':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9511,
      https_listen_port => 8411,
      http_listen_port  => 8511;
    'smartanswers':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9510,
      https_listen_port => 8410,
      http_listen_port  => 8510;
    'feedback':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9528,
      https_listen_port => 8428,
      http_listen_port  => 8528;
    'designprinciples':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9523,
      https_listen_port => 8423,
      http_listen_port  => 8523;
    'licencefinder':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9514,
      https_listen_port => 8414,
      http_listen_port  => 8514;
    'frontend':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9505,
      https_listen_port => 8405,
      http_listen_port  => 8505;
    'search':
      internal_only     => true,
      servers           => $govuk_frontend_servers,
      health_check_port => 9509,
      https_listen_port => 8409,
      http_listen_port  => 8509;
    'static':
      internal_only     => true,
      servers           => $govuk_frontend_servers,
      health_check_port => 9513,
      https_listen_port => 8413,
      http_listen_port  => 8513;
    'businesssupportfinder':
      internal_only     => true,
      servers           => $govuk_frontend_servers,
      health_check_port => 9524,
      https_listen_port => 8424,
      http_listen_port  => 8524;
  }

  # EFG frontend loadbalancers
  haproxy::balance_http_and_https {
    'efg':
      servers           => $govuk_frontend_servers,
      health_check_port => 9519,
      https_listen_port => 8419,
      http_listen_port  => 8519;
  }

}
