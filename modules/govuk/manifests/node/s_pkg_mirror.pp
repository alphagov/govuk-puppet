class govuk::node::s_pkg_mirror inherits govuk::node::s_base {
  include nginx, pip

  class { 'bandersnatch':
    document_root => '/srv/pypi',
  }

  nginx::config::site { 'bandersnatch':
    content => template('govuk/bandersnatch_nginx_vhost.erb'),
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
    content => template('govuk/aptmirror_puppet_vhost.erb'),
  }
}
