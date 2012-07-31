class elms::apps {
  include elms::apps::elms
  include elms::apps::elms_admin
  include elms::apps::elms_feed
}

class elms::apps::elms( $port = 9000 ) {
  govuk::app { 'elms':
    type               => 'procfile',
    port               => $port,
    environ_content    => 'LANG=en_GB.UTF-8\n',
    vhost_aliases      => ['licensify'],
    nginx_extra_config => template('elms/nginx_extra'),
  }
}

class elms::apps::elms_admin( $port = 9500 ) {
  govuk::app { 'elms-admin':
    type            => 'procfile',
    port            => $port,
    environ_content => 'LANG=en_GB.UTF-8\n',
  }
}

class elms::apps::elms_feed( $port = 9400 ) {
  govuk::app { 'elms-feed':
    type            => 'procfile',
    port            => $port,
    environ_content => 'LANG=en_GB.UTF-8\n',
  }
}
