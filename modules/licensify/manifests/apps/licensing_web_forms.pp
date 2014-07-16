class licensify::apps::licensing_web_forms( $port = 9001 ) inherits licensify::apps::base {

  govuk::app { 'licensing-web-forms':
    app_type            => 'procfile',
    port                => $port,
    vhost_protected     => false,
    # health_check_path => '/login', TODO
  }
}
