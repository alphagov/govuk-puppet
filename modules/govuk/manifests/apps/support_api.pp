# == Class: govuk::apps::support_api
#
# The GOV.UK application for:
#
# - storing and persisting and querying anonymous feedback data
# - pushing requests into Zendesk when necessary
#
# === Parameters
#
# [*port*]
#   The port where the Rails app is running.
#   Default: 3075
#
# [*enable_procfile_worker*]
#   Whether the Upstart-based background worker process is configured or not.
#   Default: true
#
class govuk::apps::support_api(
  $port = 3075,
  $enable_procfile_worker = true
) {
  govuk::app { 'support-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  file { ['/data/uploads/support-api', '/data/uploads/support-api/csvs']:
    ensure => directory,
    mode   => '0775',
    owner  => 'assets',
    group  => 'assets',
  }

  govuk::procfile::worker { 'support-api':
    enable_service => $enable_procfile_worker,
  }

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem
}
