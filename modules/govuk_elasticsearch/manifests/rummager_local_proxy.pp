# == Class: govuk_elasticsearch::rummager_local_proxy
#
# This is a direct copy of the govuk_elasticsearch::local_proxy
# class and has been added here to support the migration to
# Elasticsearch 2.4. The only difference being the proxy port
# which has been changed to 19200.
#
# This class should be removed once we are fully migrated.
#
# === Parameters:
#
# [*port*]
#   Port to bind on loopback and of the remote Elasticsearch servers.
#   Default: 19200
#
# [*read_timeout*]
#   Nginx `proxy_read_timeout` value.
#   Default: 60
#
# [*servers*]
#   Array of servers to load balance requests to.
#
class govuk_elasticsearch::rummager_local_proxy(
  $read_timeout = 60,
  $port = 19200,
  $remote_port = undef,
  $servers,
) {
  # Also used within template.
  $vhost      = 'rummager-elasticsearch-local-proxy'
  $log_json   = "${vhost}-json.event.access.log"
  $log_access = "${vhost}-access.log"
  $log_error  = "${vhost}-error.log"

  if($remote_port) {
    $final_remote_port = $remote_port
  } else {
    $final_remote_port = $port
  }

  nginx::config::site { $vhost:
    content => template('govuk_elasticsearch/nginx_local_proxy.conf.erb'),
  }

  nginx::log {
    $log_json:
      json      => true,
      logstream => present;
    $log_error:
      logstream => present;
  }
}
