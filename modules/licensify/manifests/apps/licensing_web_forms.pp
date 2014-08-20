class licensify::apps::licensing_web_forms( $port = 9450, $enabled = false ) inherits licensify::apps::base {
  if $enabled {
    govuk::app { 'licensing-web-forms':
      app_type          => 'procfile',
      port              => $port,
      vhost_protected   => false,
      health_check_path => '/'
    }
  }
}
