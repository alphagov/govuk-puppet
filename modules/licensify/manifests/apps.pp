class licensify::apps {
  include licensify::apps::licensify
  include licensify::apps::licensify_admin
  include licensify::apps::licensify_feed
}

class licensify::apps::licensify( $port = 9000 ) {
  govuk::app { 'licensify':
    app_type           => 'procfile',
    port               => $port,
    environ_content    => template('licensify/environ'),
    nginx_extra_config => template('licensify/nginx_extra'),
  }

  licensify::build_clean { 'licensify': }
}

class licensify::apps::licensify_admin( $port = 9500 ) {
  govuk::app { 'licensify-admin':
    app_type        => 'procfile',
    port            => $port,
    environ_content => template('licensify/environ'),
  }

  licensify::build_clean { 'licensify-admin': }
}

class licensify::apps::licensify_feed( $port = 9400 ) {
  govuk::app { 'licensify-feed':
    app_type        => 'procfile',
    port            => $port,
    environ_content => template('licensify/environ'),
  }

  licensify::build_clean { 'licensify-feed': }
}
