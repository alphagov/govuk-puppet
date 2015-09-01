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
#     - wildcard_alphagov_mgmt
#
#   wildcard_alphagov_mgmt is a special case for hostnames not bypassed by
#   govuk_select_organisation. It will fallback to wildcard_alphagov for
#   environments where the key is not present in hiera data.
#
define nginx::config::ssl( $certtype, $ensure = 'present' ) {
  case $certtype {
    'wildcard_alphagov': {
        $cert = hiera('wildcard_alphagov_crt', '')
        $key = hiera('wildcard_alphagov_key', '')
    }
    # FIXME: wildcard_alphagov_mgmt does the same thing as wildcard_alphagov
    'wildcard_alphagov_mgmt': {
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
