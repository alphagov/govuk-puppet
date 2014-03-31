class govuk::node::s_pkg_mirror inherits govuk::node::s_base {
  include nginx

  $app_domain = hiera('app_domain')

  class { 'aptmirror':
    servers => {
      'http://apt.puppetlabs.com' => {
        'lucid'   => ['main', 'devel'],
        'precise' => ['main', 'devel'],
      }
    }
  }

  nginx::config::site { 'puppet-aptmirror':
    content => template('govuk/node/s_pkg_mirror/aptmirror_nginx_vhost.erb'),
  }
}
