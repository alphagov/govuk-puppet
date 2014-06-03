class licensify::apps::licensify_admin( $port = 9500 ) inherits licensify::apps::base {

  govuk::app { 'licensify-admin':
    app_type          => 'procfile',
    port              => $port,
    vhost_protected   => false,
    health_check_path => '/login',
    require           => File['/etc/licensing'],
  }

  licensify::apps::envvars { 'licensify-admin':
    app => 'licensify-admin',
  }

  licensify::build_clean { 'licensify-admin': }
}
