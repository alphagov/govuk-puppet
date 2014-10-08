# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_whitehall_backend (
  $sync_mirror = false
) inherits govuk::node::s_base {

  include govuk::node::s_ruby_app_server
  include nginx

  include imagemagick

  class { 'govuk::apps::whitehall':
    configure_admin        => true,
    port                   => 3026,
    vhost_protected        => true,
    vhost                  => 'whitehall-admin',
    # 5GB for a warning
    nagios_memory_warning  => 5368709120,
    # 6GB for a critical
    nagios_memory_critical => 6442450944,
  }

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  if $sync_mirror {
    file { '/var/lib/govuk_mirror':
      ensure => 'directory',
      owner  => 'deploy',
      group  => 'deploy',
      mode   => '0770',
    }
    file { '/var/lib/govuk_mirror/current':
      ensure  => 'directory',
      owner   => 'deploy',
      group   => 'deploy',
      mode    => '0770',
      require => File['/var/lib/govuk_mirror'],
    }
  }

  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
