class govuk::node::s_cache inherits govuk::node::s_base {

  $protect_cache_servers         = str2bool(extlookup('protect_cache_servers', 'no'))
  $extlookup_real_ip_header      = extlookup('cache_real_ip_header', '')
  $extlookup_denied_ip_addresses = extlookup('cache_denied_ip_addresses', '')

  # FIXME: extlookup() can't return a real `undef` value. So we have to
  # proxy it to preserve the class's own default.
  $cache_real_ip_header = $extlookup_real_ip_header ? {
    ''      => undef,
    default => $extlookup_real_ip_header,
  }

  $cache_denied_ip_addresses = $extlookup_denied_ip_addresses ? {
    ''      => undef,
    default => $extlookup_denied_ip_addresses,
  }

  include govuk::htpasswd

  class { 'nginx':
    denied_ip_addresses => $cache_denied_ip_addresses,
  }

  class { 'router::nginx':
    vhost_protected => $protect_cache_servers,
    real_ip_header  => $cache_real_ip_header,
  }

  # Set the varnish storage size to 75% of memory
  $varnish_storage_size = $::memtotalmb / 4 * 3
  class { 'varnish':
    storage_size => join([$varnish_storage_size,'M'],''),
    default_ttl  => '900',
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

  case $::govuk_provider {
    'sky': {
        ufw::allow { 'Allow varnish cache bust from backend machines':
          from => '10.3.0.0/24',
          port => '7999'
        }
    }
    default: {}
  }
}
