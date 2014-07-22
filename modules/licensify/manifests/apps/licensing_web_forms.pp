class licensify::apps::licensing_web_forms( $port = 9001, $enabled = false ) inherits licensify::apps::base {
  if str2bool($enabled) {
    govuk::app { 'licensing-web-forms':
      app_type            => 'procfile',
      port                => $port,
      vhost_protected     => false,
      health_check_path => '/'
    }
  }
}
