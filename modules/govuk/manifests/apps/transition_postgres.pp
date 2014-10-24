# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::transition_postgres(
  $port = 3083,
) {
  # FIXME: clear this all out once the Postgres version is the only version
  govuk::app { 'transition-postgres':
    ensure             => 'absent',
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    vhost_protected    => false,
    deny_framing       => true,
  }

  # Clean up old Procfile worker.
  # FIXME: These can be removed once they've run on preview
  exec {'stop_transition_postgres_procfile_worker':
    command => 'service transition-postgres-procfile-worker stop || /bin/true',
    onlyif  => 'test -f /etc/init/transition-postgres-procfile-worker.conf',
  }
  file { '/etc/init/transition-postgres-procfile-worker.conf':
    ensure  => absent,
    require => Exec['stop_transition_postgres_procfile_worker'],
  }
}
