class licensify::apps::base {
  $aws_access_key_id = extlookup('aws_access_key_id', '')
  $aws_secret_key = extlookup('aws_secret_key', '')

  file { '/etc/licensing':
    ensure  => directory,
    mode    => '0755',
    owner   => 'deploy',
    group   => 'deploy',
  }
}

class licensify::apps {
  include licensify::apps::licensify
  include licensify::apps::licensify_admin
  include licensify::apps::licensify_feed
}

class licensify::apps::licensify( $port = 9000 ) inherits licensify::apps::base {

  govuk::app { 'licensify':
    app_type           => 'procfile',
    port               => $port,
    environ_content    => template('licensify/environ'),
    nginx_extra_config => template('licensify/nginx_extra'),
    health_check_path  => '/api/licences'
    require            => File['/etc/licensing'],
  }

  nginx::config::vhost::licensify_upload{ 'licensify':}
  licensify::build_clean { 'licensify': }
}

class licensify::apps::licensify_admin( $port = 9500 ) inherits licensify::apps::base {

  govuk::app { 'licensify-admin':
    app_type          => 'procfile',
    port              => $port,
    environ_content   => template('licensify/environ'),
    vhost_protected   => false,
    health_check_path => "/login"
    require           => File['/etc/licensing'],
  }

  licensify::build_clean { 'licensify-admin': }
}

class licensify::apps::licensify_feed( $port = 9400 ) inherits licensify::apps::base {

  govuk::app { 'licensify-feed':
    app_type        => 'procfile',
    port            => $port,
    environ_content => template('licensify/environ'),
    require         => File['/etc/licensing'],
  }

  licensify::build_clean { 'licensify-feed': }
}
