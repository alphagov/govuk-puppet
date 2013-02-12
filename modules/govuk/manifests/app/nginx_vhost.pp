define govuk::app::nginx_vhost (
  $vhost,
  $app_port,
  $aliases = [],
  $protected = undef,
  $ssl_only = false,
  $nginx_extra_config = '',
  $nginx_extra_app_config = '',
  $intercept_errors = false
) {

  if $protected == undef {
    $protected_real = false
  } else {
    $protected_real = $protected
  }

  nginx::config::vhost::proxy { $vhost:
    to                    => ["localhost:${app_port}"],
    aliases               => $aliases,
    protected             => $protected_real,
    ssl_only              => $ssl_only,
    extra_config          => $nginx_extra_config,
    extra_app_config      => $nginx_extra_app_config,
    intercept_errors      => $intercept_errors,
  }
}
