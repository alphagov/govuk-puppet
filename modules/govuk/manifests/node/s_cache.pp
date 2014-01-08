class govuk::node::s_cache (
  $protect_cache_servers = false,
  $real_ip_header = undef,
  $denied_ip_addresses = undef,
  $enable_gor_to_staging = false,
) inherits govuk::node::s_base {

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

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
  }

  @@nagios::check::graphite { "check_nginx_connections_writing_${::hostname}":
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


  # Hardcoded, rather than hiera, because I don't want to create the
  # illusion that you can modify these on the fly. You will need to tidy
  # up old `host{}` records.
  $staging_ip   = '217.171.99.81'
  $staging_host = 'www-origin-staging.production.alphagov.co.uk'

  if $enable_gor_to_staging {
    $gor_hosts_ensure = present
  } else {
    $gor_hosts_ensure = absent
  }

  # FIXME: This host entry serves two purposes:
  #   1. It ensures that the SSL cert on staging, which thinks it is
  #   production, matches the hostname that we connect to.
  #   2. It prevents Gor/Go from performing DNS lookups, which occur once
  #   for *every* request/goroutine, and can be quite overwhelming.
  host { $staging_host:
    ensure  => $gor_hosts_ensure,
    ip      => $staging_ip,
    comment => 'Used by Gor. See comments in s_cache.',
  }
}
