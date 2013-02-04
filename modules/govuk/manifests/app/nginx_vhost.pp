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
  # By default, apps are unprotected in Skyscape, unless they
  # explicitly declare that they want to be. Otherwise, they are protected by
  # default.
  if $protected == undef {
    $protected_real = $::govuk_provider ? {
      'sky'   => false,
      default => true,
    }
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
