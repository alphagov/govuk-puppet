class govuk::apps::support($port = 3031, $enable_procfile_worker = true) {

  govuk::app { 'support':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    nginx_extra_config => '
      location /_status {
        allow   127.0.0.0/8;
        deny    all;
      }',
    asset_pipeline     => true,
  }

  # Clean up old delayed-job worker and config.
  # These can be removed once this is pushed out to production
  exec {'stop_support_delayed_job_worker':
    command => 'initctl stop support-delayed-job-worker || /bin/true',
    onlyif  => 'test -f /etc/init/support-delayed-job-worker.conf',
  }
  file { '/etc/init/support-delayed-job-worker.conf':
    ensure  => absent,
    require => Exec['stop_support_delayed_job_worker'],
  }

  govuk::procfile::worker { 'support':
    enable_service => $enable_procfile_worker,
  }
}
