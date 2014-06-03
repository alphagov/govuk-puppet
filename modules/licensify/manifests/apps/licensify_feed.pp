class licensify::apps::licensify_feed( $port = 9400 ) inherits licensify::apps::base {

  govuk::app { 'licensify-feed':
    app_type        => 'procfile',
    port            => $port,
    vhost_protected => true,
    require         => File['/etc/licensing'],
  }

  licensify::apps::envvars { 'licensify-feed':
    app => 'licensify-feed'
  }

  licensify::build_clean { 'licensify-feed': }
}
