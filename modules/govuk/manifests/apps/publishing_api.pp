# == Class: govuk::apps::publishing_api
#
# An application to route requests between multiple content-store
# endpoints based on whether they're live or in other states.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3093
#
# [*vhost*]
#   The primary vhost for the application.  This is necessary to allow this to
#   be overridden on the dev VM where both this and the content-store are on
#   the same machine (content-store currently has a vhost alias of
#   publishing-api).  Once this has implemented the full API, content-store's
#   alias will be repointed here, and this param will no longer be needed.
#
class govuk::apps::publishing_api(
  $port = 3093,
  $vhost = 'publishing-api',
) {
  $app_name = 'publishing-api'
  govuk::app { $app_name:
    app_type           => 'bare',
    log_format_is_json => true,
    port               => $port,
    command            => "./${app_name}",
    health_check_path  => '/healthcheck',
    vhost_ssl_only     => true,
    vhost              => $vhost,
    vhost_aliases      => ['publishing-api-test'],
  }

  govuk::logstream { "${app_name}-app-out":
    ensure  => true,
    logfile => "/var/log/${app_name}/app.out.log",
    tags    => ['stdout', 'app'],
    json    => true,
    fields  => {'application' => $app_name},
  }
}
