# == Class: govuk::node::s_cache
#
# Configuration for a cache node. Runs a varnish cache and the router.
#
# === Parameters
#
# [*protect_cache_servers*]
#   Whether to protect all servers with basic auth
#
#   Default: false
#
# [*real_ip_header*]
#   The name of the upstream header containing the IP address of the user agent.
#   Nginx will use this to replace `$remote_addr` with the IP from the given header.
#
#   See router::nginx for a more detailed explanation
#
#   Default: undef
#
# [*denied_ip_addresses*]
#   Blocked IP address(es). Can be a single IP address (string) or list of IP
#   addresses (array).
#
#   Default: undef
#
# [*enable_authenticating_proxy*]
#   Whether to enable the [authenticating proxy](https://github.com/alphagov/authenticating-proxy)
#   on this node. If enabled, it will be configured to sit between varnish and
#   the router.
#
#   Default: false
#
class govuk::node::s_cache (
  $protect_cache_servers = false,
  $real_ip_header = undef,
  $denied_ip_addresses = undef,
  $enable_authenticating_proxy = false,
) inherits govuk::node::s_base {

  include govuk::htpasswd
  include router::gor

  class { 'nginx':
    denied_ip_addresses     => $denied_ip_addresses,
    variables_hash_max_size => '768',
  }

  class { 'router::nginx':
    vhost_protected => $protect_cache_servers,
    real_ip_header  => $real_ip_header,
  }

  # Set the varnish storage size to 75% of memory - 1024
  $varnish_storage_size_pre = $::memtotalmb / 4 * 3 - 1024

  # Ensure that there's some varnish storage in small environments (eg, vagrant).
  if $varnish_storage_size_pre < 100 {
    $varnish_storage_size = 100
  } else {
    $varnish_storage_size = $varnish_storage_size_pre
  }

  class { 'varnish':
    storage_size                => join([$varnish_storage_size,'M'],''),
    default_ttl                 => '900',
    enable_authenticating_proxy => $enable_authenticating_proxy,
  }

  include govuk::apps::router

  if $enable_authenticating_proxy {
    include govuk::node::s_ruby_app_server
    class { 'govuk::apps::authenticating_proxy':
      enabled            => true,
      govuk_upstream_uri => 'http://localhost:3054',
    }
  }

  @@icinga::check::graphite { "check_nginx_connections_writing_${::hostname}":
    target    => "${::fqdn_underscore}.nginx.nginx_connections-writing",
    warning   => 150,
    critical  => 250,
    desc      => 'nginx high conn writing - upstream indicator',
    host_name => $::fqdn,
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#nginx-high-conn-writing-upstream-indicator-check',
  }

  ufw::allow { 'Allow varnish cache bust from backend machines':
    from => '10.3.0.0/24',
    port => '7999'
  }
}
