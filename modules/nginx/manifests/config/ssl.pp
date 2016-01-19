# == Define: nginx::config::ssl
#
# Create Nginx certificate and private key file resources from content
# defined in hiera.
#
# === Parameters
#
# [*certtype*]
#   Mandatory key used to lookup value from hiera. It performs no other
#   magic. Permitted values:
#
#     - www
#     - wildcard_alphagov
#
define nginx::config::ssl( $certtype, $ensure = 'present' ) {
  case $certtype {
    'sflg': {
        $cert = hiera('sflg_certificate', '')
        $key = hiera('sflg_key', '')
    }
    'wildcard_alphagov': {
        $cert = hiera('wildcard_alphagov_crt', '')
        $key = hiera('wildcard_alphagov_key', '')
    }
    'www': {
        $cert = hiera('www_crt', '')
        $key = hiera('www_key', '')
    }
    default: {
        fail "${certtype} is not a valid certtype"
    }
  }

  if $ensure == 'present' {
    validate_x509_rsa_key_pair($cert, $key)
  }

  file { "/etc/nginx/ssl/${name}.crt":
    ensure  => $ensure,
    content => $cert,
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }
  file { "/etc/nginx/ssl/${name}.key":
    ensure  => $ensure,
    content => $key,
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
    mode    => '0640',
  }
}
