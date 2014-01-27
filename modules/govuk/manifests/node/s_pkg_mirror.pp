class govuk::node::s_pkg_mirror inherits govuk::node::s_base {
  include nginx, pip

  $document_root = '/srv/pypi'
  $app_domain = hiera('app_domain')

  class { 'bandersnatch':
    document_root => $document_root,
  }

  nginx::config::site { 'bandersnatch':
    content => template('govuk/node/s_pkg_mirror/bandersnatch_nginx_vhost.erb'),
  }

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
