define haproxy::balance_ssl ($servers, $listen_port, $health_check_port, $internal_only = false) {
  concat::fragment {"haproxy_listen_ssl_$title":
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/listen_fragment_ssl.erb'),
    order   => '10',
  }

  $vhost_suffix = extlookup('app_domain_suffix','dev.gov.uk')
  $vhost = "${title}.${vhost_suffix}"

  nginx::config::ssl{$vhost: certtype => "wildcard_alphagov" }
  nginx::config::site{"ssl_${vhost}":
    content => template('haproxy/nginx_ssl_proxy.erb')
  }
}
