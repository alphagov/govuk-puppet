define nginx::config::ssl( $certtype = undef ) {
  if $certtype == undef {
    if $name == 'www.gov.uk' {
      $certtype_real = "www"
    } elsif $name == 'www.preview.alphagov.co.uk' {
      $certtype_real = "www"
    } else {
      $certtype_real = "wildcard_alphagov"
    }
  }
  else {
    $certtype_real = $certtype
  }
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
