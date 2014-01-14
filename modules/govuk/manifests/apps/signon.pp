class govuk::apps::signon( $port = 3016 ) {
  govuk::app { 'signon':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/users/sign_in',
    log_format_is_json => true,
    vhost_aliases      => ['signonotron'],
    vhost_protected    => false,
    logstream          => false,
    asset_pipeline     => true,
  }

  govuk::procfile::worker {'signon': }

  # Clean up old delayed-job worker.
  # These can be removed once they've run on production
  exec {'stop_signon_delayed_job_worker':
    command => 'service signon-delayed-job-worker stop',
    onlyif  => 'test -f /etc/init/signon-delayed-job-worker.conf',
  }
  file { '/etc/init/signon-delayed-job-worker.conf':
    ensure  => absent,
    require => Exec['stop_signon_delayed_job_worker'],
  }
}
