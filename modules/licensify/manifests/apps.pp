class licensify::apps {
  include licensify::apps::licensify
  include licensify::apps::licensify_admin
  include licensify::apps::licensify_feed
}

class licensify::apps::licensify( $port = 9000 ) {
  govuk::app { 'licensify':
    type               => 'procfile',
    port               => $port,
    environ_content    => 'LANG=en_GB.UTF-8\n',
    nginx_extra_config => template('licensify/nginx_extra'),
  }
}

class licensify::apps::licensify_admin( $port = 9500 ) {
  govuk::app { 'licensify-admin':
    type            => 'procfile',
    port            => $port,
    environ_content => 'LANG=en_GB.UTF-8\n',
  }
}

class licensify::apps::licensify_feed( $port = 9400 ) {
  govuk::app { 'licensify-feed':
    type            => 'procfile',
    port            => $port,
    environ_content => 'LANG=en_GB.UTF-8\n',
  }
}
