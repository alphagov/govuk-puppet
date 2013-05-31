# == Class: elasticsearch::local_proxy
#
# Load balance connections to Elasticsearch by creating a loopback-only
# vhost in Nginx which will forward to a set of Elasticsearch servers.
#
# For the benefit of applications which use client libraries that don't
# natively support load balancing. As a bonus, it will expose logging for
# all requests to ES.
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
  $vhost = 'elasticsearch-local-proxy'

  nginx::config::site { $vhost:
    content => template('elasticsearch/nginx_local_proxy.conf.erb'),
  }
}
