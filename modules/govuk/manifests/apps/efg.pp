class govuk::apps::efg( $port = 3019 ) {

  $vhost_name = hiera('efg_domain', 'efg.dev.gov.uk')

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
    aliases               => ['efg.production.alphagov.co.uk'],
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

  @@icinga::check::graphite { "check_efg_login_failures_${::hostname}":
    target    => 'sumSeries(stats.govuk.app.efg.*.logins.failure)',
    warning   => 10,
    critical  => 15,
    desc      => 'EFG login failures',
    host_name => $::fqdn,
  }

}
