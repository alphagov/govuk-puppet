define haproxy::balance_https ($servers, $listen_port, $health_check_port, $internal_only = false) {

  $lb_name = "${title}_https"

  concat::fragment {"haproxy_listen_https_$title":
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/listen_fragment_https.erb'),
    order   => '10',
  }

  $vhost_suffix = extlookup('app_domain_suffix','dev.gov.uk')
  $vhost = "${title}.${vhost_suffix}"

  nginx::config::ssl {$vhost: certtype => "wildcard_alphagov" }
  nginx::config::site {"https_${vhost}":
    content => template('haproxy/nginx_https_proxy.erb')
  }

  @ganglia::pyconf { "haproxy_${lb_name}":
    content => template('haproxy/haproxy-ganglia.pyconf.erb'),
  }
}
