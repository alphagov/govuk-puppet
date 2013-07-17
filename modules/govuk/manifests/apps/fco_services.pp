class govuk::apps::fco_services(
  $port = 3050,
  $vhost_protected,
  $vhost_aliases = []
) {

  # Set expires headers for assets when not on a dev VM
  $extra_config = $::govuk_platform ? {
    'development' => '',
    default       => '
  location ^~ /assets/ {
    expires max;
    add_header Cache-Control public;
  }',
  }

  govuk::app { 'fco-services':
    app_type           => 'rack',
    port               => $port,
    vhost_protected    => $vhost_protected,
    health_check_path  => '/healthcheck',
    vhost_aliases      => $vhost_aliases,
    nginx_extra_config => $extra_config,
  }
}
