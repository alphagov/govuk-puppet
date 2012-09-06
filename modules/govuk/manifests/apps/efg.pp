class govuk::apps::efg( $port = 3019 ) {
  govuk::app { 'efg':
    app_type       => 'rack',
    port           => $port,
    vhost_ssl_only => true;
  }

  @@nagios::check { "check_efg_login_failures":
    check_command       => 'check_graphite_metric!stats.govuk.app.efg.logins.failure!100!100',
    service_description => 'check EFG login failures',
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
