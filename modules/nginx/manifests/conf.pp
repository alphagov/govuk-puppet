define nginx::conf (
  $ensure  = present,
  $content = undef,
  $source  = undef,
  ) {

  file { "/etc/nginx/conf.d/${title}.conf":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }

}
