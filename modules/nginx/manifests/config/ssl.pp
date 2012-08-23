define nginx::config::ssl() {
  if $name == 'www.gov.uk' {
    $cert = $name
  } elsif $name == 'www.preview.alphagov.co.uk' {
    $cert = $name
  } else {
    $cert = "static.${::govuk_platform}.alphagov.co.uk"
  }
  file { "/etc/nginx/ssl/$name.crt":
    ensure  => present,
    content => extlookup("${cert}_crt", ''),
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }
  file { "/etc/nginx/ssl/$name.key":
    ensure  => present,
    content => extlookup("${cert}_key", ''),
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }
}
