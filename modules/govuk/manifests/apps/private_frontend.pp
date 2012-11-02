class govuk::apps::private_frontend( $port = 3030 ) {
  govuk::app { 'private-frontend':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/',
  }

  # This is necessary to allow private-frontend and frontend to be deployed by the same capistrano job.
  file { "/data/vhost/frontend.${::govuk_platform}.alphagov.co.uk":
    ensure => link,
    target => "/data/vhost/private-frontend.${::govuk_platform}.alphagov.co.uk",
    owner  => 'deploy',
    group  => 'deploy',
  }
}
