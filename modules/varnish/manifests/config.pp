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

  case $::govuk_provider {
    sky: {
      $vcl_config_template = 'default-with-routing.vcl.erb',
    }
    default: {
      $vcl_config_template = $::govuk_platform ? {
        preview => 'default-with-routing.vcl.erb',
        default => 'default.vcl.erb',
      }
    }
  }
  
  file { '/etc/varnish/default.vcl':
    ensure  => file,
    content => template("varnish/${vcl_config_template}"),
    require => Package['varnish'],
  }
}
