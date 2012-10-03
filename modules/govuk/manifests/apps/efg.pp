class govuk::apps::efg( $port = 3019 ) {
  govuk::app { 'efg':
    app_type          => 'rack',
    port              => $port,
    health_check_path => "/",
    vhost_ssl_only    => true;
  }

  @@nagios::check { "check_efg_login_failures":
    check_command       => 'check_graphite_metric!stats.govuk.app.efg.logins.failure!10!15',
    use                 => 'govuk_medium_priority',
    service_description => 'check EFG login failures',
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
