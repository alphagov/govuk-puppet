class govuk::node::s_aptmirror inherits govuk::node::s_base {
  include nginx
  class { 'aptmirror':
      servers => {
        'http://apt.puppetlabs.com' => {
          'lucid'   => ['main', 'devel'],
          'precise' => ['main', 'devel'],
        }
      }
  }
  nginx::config::site { 'puppet-aptmirror':
    content => "
      server {
        listen   80;
        root /var/spool/apt-mirror/mirror/apt.puppetlabs.com;
        server_name aptmirror.production.alphagov.co.uk;
        location / {
          autoindex on;
          try_files \$uri \$uri/ =404;
        }
      }
    "
  }
}
