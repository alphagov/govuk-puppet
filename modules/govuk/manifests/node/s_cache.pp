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
#   the router and basic authentication will be disabled (i.e. protect_cache_servers is ignored)
#
#   Default: false
#
# [*router_as_container*]
#   Set to true to run Router as a container in Docker.
#
class govuk::node::s_cache (
  $protect_cache_servers = false,
  $real_ip_header = undef,
  $denied_ip_addresses = undef,
  $enable_authenticating_proxy = false,
  $router_as_container = false,
) inherits govuk::node::s_base {

  include govuk_htpasswd
  include router::gor
  include nscd

  # The next two blocks increase file descriptor and IP connection
  # tracking limits on cache machines so the router can handle more
  # simultaneous connections. The router is the only app on these
  # machines, so we can afford for it to use more resources.
  limits::limits { 'deploy_nofile_router':
    ensure     => present,
    user       => 'deploy',
    limit_type => 'nofile',
    both       => 65536,
  }

  govuk_harden::sysctl::conf { 'cache-nf-conntrack-limit':
    ensure  => absent,
    content => "net.netfilter.nf_conntrack_max = 65536\n",
  }

  if $router_as_container {
    include ::govuk_containers::apps::router
  }

  class { 'nginx':
    denied_ip_addresses     => $denied_ip_addresses,
    variables_hash_max_size => '768',
  }

  # Ensure basic auth is off if authenticating-proxy is enabled
  if $enable_authenticating_proxy {
    $vhost_protected = false
  } else {
    $vhost_protected = $protect_cache_servers
  }

  class { 'router::nginx':
    vhost_protected => $vhost_protected,
    real_ip_header  => $real_ip_header,
  }

  # The storage size for the cache, excluding per object and static overheads
  $varnish_storage_size_pre = floor($::memorysize_mb * 0.70 - 3072)

  # Ensure that there's some varnish storage in small environments (eg, vagrant).
  if $varnish_storage_size_pre < 100 {
    $varnish_storage_size = 100
  } else {
    $varnish_storage_size = $varnish_storage_size_pre
  }

  $varnish_upstream_port = $enable_authenticating_proxy ? {
    true => 3107,
    default => 3054,
  }

  $strip_cookies = $enable_authenticating_proxy ? {
    true    => false,
    default => true,
  }

  class { 'varnish':
    storage_size  => join([$varnish_storage_size,'M'],''),
    default_ttl   => '900',
    upstream_port => $varnish_upstream_port,
    strip_cookies => $strip_cookies,
  }

  @ufw::allow {
    'allow-cache-clearing-from-all':
      port => 7999;
  }

  @@icinga::check::graphite { "check_nginx_connections_writing_${::hostname}":
    target    => "${::fqdn_metrics}.nginx.nginx_connections-writing",
    warning   => 150,
    critical  => 250,
    desc      => 'nginx high conn writing - upstream indicator',
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(nginx-high-conn-writing-upstream-indicator-check),
  }
}
