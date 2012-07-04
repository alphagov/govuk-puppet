class varnish::config {
  file { '/etc/default/varnish':
    ensure  => file,
    content => template('varnish/defaults.erb'),
    require => Package['varnish']
  }

  file { '/etc/default/varnishncsa':
    ensure  => file,
    source  => 'puppet:///modules/varnish/ncsa-defaults',
    require => Package['varnish']
  }

  file { '/etc/varnish/default.vcl':
    ensure  => file,
    content => template('varnish/default.vcl.erb'),
    require => Package['varnish'],
  }
}
