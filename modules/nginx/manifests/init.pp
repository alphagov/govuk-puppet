class nginx {
  include logster
  include graylogtail

  exec { 'nginx_reload':
    command     => '/etc/init.d/nginx reload',
    refreshonly => true,
    onlyif      => '/etc/init.d/nginx configtest',
  }

  exec { 'nginx_restart':
    command     => '/etc/init.d/nginx restart',
    refreshonly => true,
    onlyif      => '/etc/init.d/nginx configtest',
  }
  include nginx::install
  include nginx::service
}
