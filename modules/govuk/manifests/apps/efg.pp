class govuk::apps::efg( $port = 3019 ) {

  $vhost_name = extlookup('efg_domain', 'efg.dev.gov.uk')

  govuk::app { 'efg':
    app_type           => 'rack',
    port               => $port,
    enable_nginx_vhost => false,
    health_check_path  => '/healthcheck',
  }

  govuk::app::envvar { 'EFG_HOST':
    app   => 'efg',
    value => $vhost_name,
  }

  nginx::config::vhost::proxy { $vhost_name:
    to                    => ["localhost:${port}"],
    aliases               => ["efg.production.alphagov.co.uk"],
    protected             => false,
    ssl_only              => true,
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

  @@nagios::check { "check_efg_login_failures_${::hostname}":
    check_command       => 'check_graphite_metric!sumSeries(stats.govuk.app.efg.*.logins.failure)!10!15',
    use                 => 'govuk_normal_priority',
    service_description => 'EFG login failures',
    host_name           => $::fqdn,
  }

}
