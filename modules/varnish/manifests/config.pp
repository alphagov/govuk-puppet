class varnish::config {
  file { '/etc/default/varnish':
    ensure  => file,
    content => template('varnish/defaults.erb'),
    require => Package['varnish']
  }

  file { '/etc/default/varnishncsa':
    ensure  => file,
    source  => 'puppet:///modules/varnish/etc/default/varnishncsa',
    require => Package['varnish']
  }

  file { '/etc/varnish/default.vcl':
    ensure  => file,
    content => template('varnish/default.vcl.erb'),
    require => Package['varnish'],
  }
  file { '/etc/logstash/':
    ensure  => directory
  }
  file { '/etc/logstash/logstash-client/':
    ensure  => directory,
    require => File['/etc/logstash/']
  }
}
