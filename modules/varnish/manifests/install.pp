class varnish::install {

  package { 'varnish':
    ensure => installed
  }

  file { '/etc/default/varnish':
    ensure  => file,
    content  => template('varnish/defaults.erb'),
    require => Package['varnish']
  }

  case $::lsbdistcodename {
    # in Varnish3, the purge function became ban
    'lucid' : {
        $varnish_version = 2
    }
    default: {
        $varnish_version = 3
    }
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
