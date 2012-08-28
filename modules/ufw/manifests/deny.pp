define ufw::deny($proto='tcp', $port='all', $ip='', $from='any') {

  if $::ipaddress_eth0 != undef {
    $ipadr = $ip ? {
      ''      => $::ipaddress_eth0,
      default => $ip,
    }
  } else {
    $ipadr = 'any'
  }

  $from_match = $from ? {
    'any'   => 'Anywhere',
    default => "$from/$proto",
  }

  $command = $port ? {
    'all'   => "ufw deny proto $proto from $from to $ipadr",
    default => "ufw deny proto $proto from $from to $ipadr port $port",
  },

  $unless  = $port ? {
    'all'   => "ufw status | grep -E \"$ipadr/$proto +DENY +$from_match\"",
    default => "ufw status | grep -E \"$ipadr $port/$proto +DENY +$from_match\"",
  },

  exec { "ufw-deny-${proto}-from-${from}-to-${ipadr}-port-${port}":
    command => $command,
    unless  => $unless,
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }
}
