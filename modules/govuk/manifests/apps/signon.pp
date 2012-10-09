class govuk::apps::signon( $port = 3016 ) {
  govuk::app { 'signon':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => "/users/sign_in",
    vhost_aliases     => ['signonotron'],
    vhost_protected   => false
  }

  @@nagios::check { "check_signon_login_failures_${::hostname}":
  # thresholds based on checking per-host, would be higher per-app
    check_command       => 'check_graphite_metric!stats.govuk.app.signon.logins.failure!5!10',
    service_description => 'check Sign-On-O-Tron login failures',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_signon_accounts_suspended_${::hostname}": 
    # thresholds based on checking per-host, would be higher per-app
    check_command       => 'check_graphite_metric!stats.govuk.app.signon.users.suspend!2!3',
    service_description => 'check Sign-On-O-Tron user suspensions',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_signon_accounts_created_${::hostname}":
    # thresholds based on checking per-host, would be higher per-app
    check_command       => 'check_graphite_metric!stats.govuk.app.signon.users.created!2!3',
    service_description => 'check Sign-On-O-Tron users created',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_signon_password_reset_requests_${::hostname}":
    # thresholds based on checking per-host, would be higher per-app
    check_command       => 'check_graphite_metric!stats.govuk.app.signon.users.password_reset_request!2!3',
    service_description => 'check Sign-On-O-Tron password reset requests',
    host_name           => "${::govuk_class}-${::hostname}",
  }  
}
