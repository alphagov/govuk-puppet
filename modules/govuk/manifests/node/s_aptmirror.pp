class govuk::node::s_aptmirror inherits govuk::node::s_base {
  class { 'aptmirror':
    servers => {
    'http://apt.puppetlabs.com' => {
      'lucid' => ['main', 'devel']
      }
      }
    }
  }
