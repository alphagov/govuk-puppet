class varnish::config {
  include varnish::restart

  $app_domain  = hiera('app_domain')
  $router_port = '3054'

  file { '/etc/default/varnish':
    ensure  => file,
    content => template('varnish/defaults.erb'),
    notify  => Class['varnish::restart'], # requires a full varnish restart to pick up changes
  }

  file { '/etc/default/varnishncsa':
    ensure  => file,
    source  => 'puppet:///modules/varnish/etc/default/varnishncsa',
  }

  file { '/etc/varnish/default.vcl':
    ensure  => file,
    content => template('varnish/default.vcl.erb'),
  }
}
