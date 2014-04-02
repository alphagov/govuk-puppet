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
#     - wildcard_alphagov_mgmt
#
#   wildcard_alphagov_mgmt is a special case for hostnames not bypassed by
#   govuk_select_organisation. It will fallback to wildcard_alphagov for
#   environments where the key is not present in extlookup.
#
define nginx::config::ssl( $certtype ) {
  if ! ($certtype in [
      'www',
      'ci_alphagov',
      'wildcard_alphagov',
      'wildcard_alphagov_mgmt'
    ]) {
    fail "${certtype} is not a valid certtype"
  }

  if $certtype == 'wildcard_alphagov_mgmt' {
    $cert = extlookup("${certtype}_crt", extlookup('wildcard_alphagov_crt', ''))
    $key = extlookup("${certtype}_key", extlookup('wildcard_alphagov_key', ''))
  } else {
    $cert = extlookup("${certtype}_crt", '')
    $key = extlookup("${certtype}_key", '')
  }

  file { "/etc/nginx/ssl/${name}.crt":
    ensure  => present,
    content => $cert,
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }
  file { "/etc/nginx/ssl/${name}.key":
    ensure  => present,
    content => $key,
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }
}
