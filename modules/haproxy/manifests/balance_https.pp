define haproxy::balance_https (
    $servers,
    $listen_port,
    $health_check_port,
    $internal_only = false,
    $aliases = [],
    $health_check_method = 'HEAD',
    $health_check_path = '/') {

  $lb_name = "${title}-https"

  $vhost_suffix = extlookup('app_domain','dev.gov.uk')
  $vhost = "${title}.${vhost_suffix}"

  concat::fragment {"haproxy_listen_https_$title":
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/listen_fragment_https.erb'),
    order   => '10',
  }

  nginx::config::ssl {$vhost: certtype => "wildcard_alphagov" }
  nginx::config::site {"https_${vhost}":
    content => template('haproxy/nginx_https_proxy.erb')
  }
}
