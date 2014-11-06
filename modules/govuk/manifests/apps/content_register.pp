# == Class: govuk::apps::content_register
#
# The register of all content created by publishing applications.
# Read more: https://github.com/alphagov/content-register
#
# === Parameters
#
# [*port*]
#   The port that content-register API is served on.
#   Default: 3077
#
class govuk::apps::content_register(
  $port = 3077,
  $enable_procfile_worker = true,
) {
  govuk::app { 'content-register':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem

  govuk::procfile::worker {'content-register':
    enable_service => $enable_procfile_worker,
  }
}
