define govuk::app::nginx_vhost (
  $vhost,
  $app_port,
  $aliases = [],
  $protected = undef,
  $ssl_only = false,
  $nginx_extra_config = '',
  $platform = $::govuk_platform,
  $health_check_path = 'NOTSET',
  $nginx_extra_app_config = '',
  $intercept_errors = false
) {
  if $health_check_path == 'NOTSET' {
    $health_check_port = 'NOTSET'
    $ssl_health_check_port = 'NOTSET'
  } else {
    $health_check_port = $app_port + 6500
    $ssl_health_check_port = $app_port + 6400
    @ufw::allow {
      "allow-loadbalancer-health-check-${title}-http-from-all":
        port => $health_check_port;
      "allow-loadbalancer-health-check-${title}-https-from-all":
        port => $ssl_health_check_port;
    }
  }

  nginx::config::vhost::proxy { $vhost:
    to                    => ["localhost:${app_port}"],
    aliases               => $aliases,
    protected             => $protected,
    ssl_only              => $ssl_only,
    extra_config          => $nginx_extra_config,
    extra_app_config      => $nginx_extra_app_config,
    platform              => $platform,
    health_check_path     => $health_check_path,
    health_check_port     => $health_check_port,
    intercept_errors      => $intercept_errors,
    ssl_health_check_port => $ssl_health_check_port,
  }
}
