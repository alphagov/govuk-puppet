class govuk::node::s_cache inherits govuk::node::s_base {

  $protect_cache_servers = str2bool(extlookup('protect_cache_servers', 'no'))

  include govuk::htpasswd
  include nginx

  class { 'router::nginx':
    vhost_protected => $protect_cache_servers
  }

  # Set the varnish storage size to 75% of memory
  $varnish_storage_size = $::memtotalmb / 4 * 3
  class { 'varnish':
    storage_size => join([$varnish_storage_size,"M"],""),
    default_ttl  => '900',
  }

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
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
