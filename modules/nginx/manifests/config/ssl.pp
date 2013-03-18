# == Define: nginx::config::ssl
#
# Create Nginx certificate and private key file resources from content
# defined in extdata.
#
# === Parameters
#
# [*certtype*]
#   Mandatory key used to lookup value from extlookup. It performs no other
#   magic. Permitted values:
#
#     - www
#     - ci_alphagov
#     - wildcard_alphagov
#
define nginx::config::ssl( $certtype ) {
  if ! ($certtype in ['www', 'ci_alphagov', 'wildcard_alphagov']) {
    fail "${certtype} is not a valid certtype"
  }

  file { "/etc/nginx/ssl/${name}.crt":
    ensure  => present,
    content => extlookup("${certtype}_crt", ''),
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }
  file { "/etc/nginx/ssl/${name}.key":
    ensure  => present,
    content => extlookup("${certtype}_key", ''),
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }
}
