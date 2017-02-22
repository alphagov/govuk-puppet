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
#     - wildcard_publishing
#     - www
#
define nginx::config::ssl( $certtype, $ensure = 'present' ) {
  case $certtype {
    'wildcard_publishing': {
        $cert = hiera('wildcard_publishing_certificate', '')
        $key = hiera('wildcard_publishing_key', '')
    }
    'www': {
        $cert = hiera('www_crt', '')
        $key = hiera('www_key', '')
    }
    default: {
        fail "${certtype} is not a valid certtype"
    }
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
