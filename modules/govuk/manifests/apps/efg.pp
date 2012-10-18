class govuk::apps::efg( $port = 3019 ) {
  govuk::app { 'efg':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => "/healthcheck",
    enable_nginx_vhost => false,
  }

  nginx::config::vhost::proxy { "www.sflg.gov.uk":
    to                => ["localhost:${port}"],
    protected         => false,
    ssl_only          => true,
    extra_config => '
  location /sflg/ {
    rewrite ^ https://$server_name/? permanent;
  }

  location /training/ {
    rewrite ^ https://efg.production.alphagov.co.uk/? redirect;
  }
';
  }

  @@nagios::check { "check_efg_login_failures_${::hostname}":
    check_command       => 'check_graphite_metric!stats.govuk.app.efg.logins.failure!10!15',
    use                 => 'govuk_normal_priority',
    service_description => 'EFG login failures',
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
