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
  case $certtype {
    'ci_alphagov': {
        $cert = chomp(hiera('ci_alphagov_crt', ''))
        $key = chomp(hiera('ci_alphagov_key', ''))
    }
    'wildcard_alphagov': {
        $cert = chomp(hiera('wildcard_alphagov_crt', ''))
        $key = chomp(hiera('wildcard_alphagov_key', ''))
    }
    'wildcard_alphagov_mgmt': {
        # The below two lines are hard to mentally parse, but if the certtype is set to
        # 'wildcard_alphagov_mgmt' then it will first look for certs and keys for that.
        # If they don't exist in hiera, it will fall back to looking for 'wildcard_alphagov'
        # and if that fails, will return the empty string.
        #FIXME: chomp() is to maintain md5 between previous extlookup - can be removed once deployed
        $cert = chomp(hiera('wildcard_alphagov_mgmt_crt', hiera('wildcard_alphagov_crt', '')))
        $key = chomp(hiera('wildcard_alphagov_mgmt_key', hiera('wildcard_alphagov_key', '')))
    }
    'www': {
        $cert = chomp(hiera('www_crt', ''))
        $key = chomp(hiera('www_key', ''))
    }
    default: {
        fail "${certtype} is not a valid certtype"
    }
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
    mode    => '0640',
  }
}
