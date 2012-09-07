define nginx::config::ssl( $certtype ) {
  if ! ($certtype in ['www','wildcard_alphagov']) {
    fail "${certtype} is not a valid certtype"
  }
  $certtype_real = $certtype

  file { "/etc/nginx/ssl/$name.crt":
    ensure  => present,
    content => extlookup("${certtype_real}_crt", ''),
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }
  file { "/etc/nginx/ssl/$name.key":
    ensure  => present,
    content => extlookup("${certtype_real}_key", ''),
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }
}
