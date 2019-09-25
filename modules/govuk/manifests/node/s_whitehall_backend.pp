# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_whitehall_backend (
  $sync_mirror = false
) inherits govuk::node::s_base {

  include govuk::node::s_app_server

  include nginx

  include imagemagick

  # Package required in order to use PDFKit
  ensure_packages(['wkhtmltopdf'])

  # The catchall vhost throws a 500, except for healthcheck requests.
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
    listen_ip  => '0.0.0.0',
  }
}
