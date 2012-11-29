class govuk_node::frontend_load_balancer {
  include govuk_node::base

  include haproxy
  include loadbalancer::cron

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

  $app_domain = extlookup('app_domain')

  # Some idiot (Hi!) named something that's a URL 'host'. Sorry. -NS
  $asset_url = extlookup('asset_host')
  $asset_host = regsubst($asset_url, "https?://(.+)", '\1')

  # Frontend Load Balancers
  haproxy::balance_http_and_https {
    'businesssupportfinder':
      internal_only     => true,
      servers           => $govuk_frontend_servers,
      health_check_port => 9524,
      https_listen_port => 8424,
      http_listen_port  => 8524;
    'calendars':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9511,
      https_listen_port => 8411,
      http_listen_port  => 8511;
    'canary-frontend':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9700,
      https_listen_port => 8600,
      http_listen_port  => 8700;
    'datainsight-frontend':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9527,
      https_listen_port => 8427,
      http_listen_port  => 8527;
    'designprinciples':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9523,
      https_listen_port => 8423,
      http_listen_port  => 8523;
    'feedback':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9528,
      https_listen_port => 8428,
      http_listen_port  => 8528;
    'frontend':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9505,
      https_listen_port => 8405,
      http_listen_port  => 8505,
      aliases           => ["www.${app_domain}"]; # TODO: remove this alias once we're sure it's not being used.
    'licencefinder':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9514,
      https_listen_port => 8414,
      http_listen_port  => 8514;
    'smartanswers':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9510,
      https_listen_port => 8410,
      http_listen_port  => 8510;
    'static':
      internal_only     => false,
      servers           => $govuk_frontend_servers,
      health_check_port => 9513,
      https_listen_port => 8413,
      http_listen_port  => 8513,
      aliases           => [$asset_host];
    'tariff':
      servers           => $govuk_frontend_servers,
      internal_only     => true,
      health_check_port => 9517,
      https_listen_port => 8417,
      http_listen_port  => 8517;
  }

  # Whitehall Frontend Load Balancers
  haproxy::balance_http_and_https {
    'whitehall-frontend':
      servers           => $whitehall_frontend_servers,
      internal_only     => true,
      health_check_port => 9520,
      https_listen_port => 8420,
      http_listen_port  => 8520;
  }

  # EFG frontend loadbalancers
  haproxy::balance_http_and_https {
    'efg':
      servers           => $efg_frontend_servers,
      health_check_port => 9519,
      https_listen_port => 8419,
      http_listen_port  => 8519;
  }

  # public api
  include govuk::apps::publicapi
}
