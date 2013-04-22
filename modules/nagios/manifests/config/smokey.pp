class nagios::config::smokey {
  $smokey_vars = {
    'AUTH_USERNAME'   => extlookup('http_username', 'UNSET'),
    'AUTH_PASSWORD'   => extlookup('http_password', 'UNSET'),
    'EFG_DOMAIN'      => extlookup('smokey_efg_domain', 'UNSET'),
    'EFG_USERNAME'    => extlookup('smokey_efg_username', 'UNSET'),
    'EFG_PASSWORD'    => extlookup('smokey_efg_password', 'UNSET'),
    'SIGNON_EMAIL'    => extlookup('smokey_signon_email', 'UNSET'),
    'SIGNON_PASSWORD' => extlookup('smokey_signon_password', 'UNSET'),
    'BEARER_TOKEN'    => extlookup('smokey_bearer_token', 'UNSET'),
  }

  file { '/etc/smokey.sh':
    content => template('nagios/etc/smokey.sh.erb'),
    owner   => 'nagios',
    mode    => '0400',
  }

  file { '/etc/nagios3/conf.d/check_smokey.cfg':
    source => 'puppet:///modules/nagios/files/etc/nagios3/conf.d/check_smokey.cfg',
  }
}
