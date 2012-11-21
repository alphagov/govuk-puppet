class licensify::apps::base {

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
    nginx_extra_config => template('licensify/nginx_extra'),
    health_check_path  => '/api/licences',
    require            => File['/etc/licensing'],
  }

  licensify::apps::envvars { 'licensify':
    app => 'licensify',
  }

  nginx::config::vhost::licensify_upload{ 'licensify':}
  licensify::build_clean { 'licensify': }
}

class licensify::apps::licensify_admin( $port = 9500 ) inherits licensify::apps::base {

  govuk::app { 'licensify-admin':
    app_type          => 'procfile',
    port              => $port,
    vhost_protected   => false,
    health_check_path => "/login",
    require           => File['/etc/licensing'],
  }

  licensify::apps::envvars { 'licensify-admin':
    app => 'licensify-admin',
  }

  licensify::build_clean { 'licensify-admin': }
}

class licensify::apps::licensify_feed( $port = 9400 ) inherits licensify::apps::base {

  govuk::app { 'licensify-feed':
    app_type        => 'procfile',
    port            => $port,
    require         => File['/etc/licensing'],
  }

  licensify::apps::envvars { 'licensify-feed':
    app => 'licensify-feed'
  }

  licensify::build_clean { 'licensify-feed': }
}

define licensify::apps::envvars($app) {
  $aws_access_key_id = extlookup('aws_access_key_id', '')
  $aws_secret_key = extlookup('aws_secret_key', '')

  Govuk::App::Envvar {
    app => $app,
  }
  govuk::app::envvar { 'LANG':
    value => 'en_GB.UTF-8',
  }
  govuk::app::envvar { 'AWS_ACCESS_KEY_ID':
    value => $aws_access_key_id,
  }
  govuk::app::envvar { 'AWS_SECRET_KEY':
    value => $aws_secret_key,
  }
}
