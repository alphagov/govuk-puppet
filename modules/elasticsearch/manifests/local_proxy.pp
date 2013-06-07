# == Class: elasticsearch::local_proxy
#
# Load balance connections to Elasticsearch by creating a loopback-only
# vhost in Nginx which will forward to a set of Elasticsearch servers.
#
# This is for the benefit of applications with client libraries that don't
# support native cluster awareness or load balancing.
#
# Using loopback rather than a separate load balancer node prevents network
# contention at a single point. Binding to loopback prevents the service
# from being exposed to clients on other nodes. And as a bonus, we get
# logging of all requests to ES.
#
# === Parameters:
#
# [*port*]
#   Port to bind on loopback and of the remote Elasticsearch servers.
#   Default: 9200
#
# [*read_timeout*]
#   Nginx `proxy_read_timeout` value.
#   Default: 5
#
# [*servers*]
#   Array of servers to load balance requests to.
#
class elasticsearch::local_proxy(
  $read_timeout = 5,
  $port = 9200,
  $servers
) {
  # Also used within template.
  $vhost      = 'elasticsearch-local-proxy'
  $log_json   = "${vhost}-json.event.access.log"
  $log_access = "${vhost}-access.log"
  $log_error  = "${vhost}-error.log"

  nginx::config::site { $vhost:
    content => template('elasticsearch/nginx_local_proxy.conf.erb'),
  }

  nginx::log {
    $log_json:
      json      => true,
      logstream => true;
    $log_access:
      logstream => false;
    $log_error:
      logstream => true;
  }
}
