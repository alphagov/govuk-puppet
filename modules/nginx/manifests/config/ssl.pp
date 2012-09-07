define nginx::config::ssl( $certtype = undef ) {
  if $certtype == undef {
    if $name == 'www.gov.uk' {
      $certtype = "www"
    } elsif $name == 'www.preview.alphagov.co.uk' {
      $certtype = "www"
    } else {
      $certtype = "wildcard_alphagov"
    }
  }
  file { "/etc/nginx/ssl/$name.crt":
    ensure  => present,
    content => extlookup("${certtype}_crt", ''),
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }
  file { "/etc/nginx/ssl/$name.key":
    ensure  => present,
    content => extlookup("${certtype}_key", ''),
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }
}
