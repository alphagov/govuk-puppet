class govuk::apps::efg( $port = 3019 ) {

  $vhost_name = extlookup('efg_domain', 'efg.dev.gov.uk')

  govuk::app { 'efg':
    app_type           => 'rack',
    port               => $port,
    enable_nginx_vhost => false,
  }

  govuk::app::envvar { 'EFG_HOST':
    app   => 'efg',
    value => $vhost_name,
  }

  # BEWARE A BODGE
  #
  # Because the EFG app lives, unprotected, at, efg_domain (probably
  # www.sflg.gov.uk), I've had to copy and paste some of the health check code
  # from govuk::app. Ideally, we'd move this back to
  # efg.production.alphagov.co.uk or similar, and terminate SSL for
  # www.sflg.gov.uk independently at the top of the stack.
  #
  # -NS 2012-10-19

  $health_check_path = "/healthcheck"
  $health_check_port = $port + 6500
  $ssl_health_check_port = $port + 6400
  @ufw::allow {
    "allow-loadbalancer-health-check-efg-http-from-all":
      port => $health_check_port;
    "allow-loadbalancer-health-check-efg-https-from-all":
      port => $ssl_health_check_port;
  }

  nginx::config::vhost::proxy { $vhost_name:
    to                    => ["localhost:${port}"],
    aliases               => ["efg.production.alphagov.co.uk"],
    protected             => false,
    health_check_path     => $health_check_path,
    health_check_port     => $health_check_port,
    ssl_only              => true,
    ssl_health_check_port => $ssl_health_check_port,
    ssl_manage_cert       => false,
    extra_config          => '
  location /sflg/ {
    rewrite ^ https://$server_name/? permanent;
  }

  location /training/ {
    rewrite ^ https://training.sflg.gov.uk/? redirect;
  }
';
  }

  @@nagios::check { "check_app_efg_up_on_${::hostname}":
    check_command       => "check_nrpe!check_app_up!${port} ${health_check_path}",
    service_description => "efg app running",
    host_name           => $::fqdn,
  }

  @@nagios::check { "check_efg_login_failures_${::hostname}":
    check_command       => 'check_graphite_metric!sumSeries(stats.govuk.app.efg.*.logins.failure)!10!15',
    use                 => 'govuk_normal_priority',
    service_description => 'EFG login failures',
    host_name           => $::fqdn,
  }

}
