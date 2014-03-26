class govuk::node::s_cache (
  $protect_cache_servers = false,
  $real_ip_header = undef,
  $denied_ip_addresses = undef,
) inherits govuk::node::s_base {

  include govuk::gor
  include govuk::htpasswd

  class { 'nginx':
    denied_ip_addresses => $denied_ip_addresses,
  }

  class { 'router::nginx':
    vhost_protected => $protect_cache_servers,
    real_ip_header  => $real_ip_header,
  }

  # Set the varnish storage size to 75% of memory
  $varnish_storage_size = $::memtotalmb / 4 * 3
  class { 'varnish':
    storage_size => join([$varnish_storage_size,'M'],''),
    default_ttl  => '900',
  }

  class { 'govuk::apps::router':
    mongodb_nodes => [
      'router-backend-1.router',
      'router-backend-2.router',
      'router-backend-3.router',
    ],
  }

  @@icinga::check::graphite { "check_nginx_connections_writing_${::hostname}":
    target       => "${::fqdn_underscore}.nginx.nginx_connections-writing",
    warning      => 150,
    critical     => 250,
    desc         => 'nginx high conn writing - upstream indicator',
    host_name    => $::fqdn,
    notes_url    => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#nginx-high-conn-writing-upstream-indicator-check',
  }

  ufw::allow { 'Allow varnish cache bust from backend machines':
    from => '10.3.0.0/24',
    port => '7999'
  }
}
