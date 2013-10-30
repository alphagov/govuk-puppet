class icinga::config::smokey {
  $smokey_vars = {
    'AUTH_USERNAME'              => extlookup('http_username', 'UNSET'),
    'AUTH_PASSWORD'              => extlookup('http_password', 'UNSET'),
    'EFG_DOMAIN'                 => extlookup('smokey_efg_domain', 'UNSET'),
    'EFG_USERNAME'               => extlookup('smokey_efg_username', 'UNSET'),
    'EFG_PASSWORD'               => extlookup('smokey_efg_password', 'UNSET'),
    'SIGNON_EMAIL'               => extlookup('smokey_signon_email', 'UNSET'),
    'SIGNON_PASSWORD'            => extlookup('smokey_signon_password', 'UNSET'),
    'BEARER_TOKEN'               => extlookup('smokey_bearer_token', 'UNSET'),
    'FCO_SERVICES_DOMAIN_PREFIX' => extlookup('fco_services_domain_prefix', 'UNSET'),
  }

  file { '/etc/smokey.sh':
    content => template('icinga/etc/smokey.sh.erb'),
    mode    => '0400',
  }

  file { '/etc/icinga/conf.d/check_smokey.cfg':
    source => 'puppet:///modules/icinga/etc/icinga/conf.d/check_smokey.cfg',
  }
}
