define haproxy::balance ($servers, $listen_port, $health_check_port) {
  concat::fragment {"haproxy_listen_$title":
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/listen_fragment.erb'),
    order   => 10,
  }

  include nginx

  $vhost_suffix = extlookup('app_domain_suffix','dev.gov.uk')
  $vhost = "${title}.${vhost_suffix}"
  $ssl_only = true

  nginx::config::ssl{$vhost: certtype => "wildcard_alphagov" }
  nginx::config::site{$vhost:
    content => template('haproxy/nginx_ssl_proxy.erb')
  }
}
