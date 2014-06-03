class licensify::apps::licensify( $port = 9000 ) inherits licensify::apps::base {

  $protect_licensify_frontend = str2bool(extlookup('protect_frontend_apps', 'no'))

  govuk::app { 'licensify':
    app_type           => 'procfile',
    port               => $port,
    vhost_protected    => $protect_licensify_frontend,
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
