class govuk::node::s_cache inherits govuk::node::s_base {

  $protect_cache_servers    = str2bool(extlookup('protect_cache_servers', 'no'))
  $extlookup_real_ip_header = extlookup('cache_real_ip_header', '')

  # FIXME: extlookup() can't return a real `undef` value. So we have to
  # proxy it to preserve the class's own default.
  $cache_real_ip_header = $extlookup_real_ip_header ? {
    ''      => undef,
    default => $extlookup_real_ip_header,
  }

  include govuk::htpasswd
  include nginx

  class { 'router::nginx':
    vhost_protected => $protect_cache_servers,
    real_ip_header  => $cache_real_ip_header,
  }

  # the assets-origin stuff here is WIP, will be extracted into a
  # separate class before finishing the story
  # -- @philippotter 2013-06-19
  $app_domain = extlookup('app_domain')
  if $::govuk_platform == 'preview' {
    # suspect we want `protected => false` here
    # once appropriate firewalling is in place?
    nginx::config::vhost::proxy { 'assets-origin.digital.cabinet-office.gov.uk':
      to       => ["static.${app_domain}"],
      ssl_only => true,
    }
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
