class govuk::apps::signon( $port = 3016 ) {
  govuk::app { 'signon':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => "/users/sign_in",
    vhost_aliases     => ['signonotron'],
    vhost_protected   => false
  }

  @@nagios::check { "check_signon_login_failures":
    check_command       => 'check_graphite_metric!stats.govuk.app.signon.logins.failure!20!50',
    service_description => 'check Sign-On-O-Tron login failures',
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
