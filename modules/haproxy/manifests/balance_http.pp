define haproxy::balance_http ($servers, $listen_port, $health_check_port, $internal_only = false, $aliases=[]) {

  $lb_name = "${title}-http"

  concat::fragment {"haproxy_listen_http_$title":
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/listen_fragment_http.erb'),
    order   => '10',
  }

  $vhost_suffix = extlookup('app_domain_suffix','dev.gov.uk')
  $vhost = "${title}.${vhost_suffix}"

  nginx::config::site{"http_${vhost}":
    content => template('haproxy/nginx_http_proxy.erb')
  }
}
