class graphite::nginx {
  include ::nginx

  nginx::config::vhost::proxy { 'graphite':
    to        => ['localhost:33333'],
    root      => '/opt/graphite/webapp',
    aliases   => ['graphite.*'],
    protected => str2bool(extlookup('monitoring_protected','yes')),
  }
}
