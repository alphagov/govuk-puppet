define ufw::allow($proto='tcp', $port='all', $ip='', $from='any') {

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

  $command  =  $port ? {
    'all'   => "ufw allow proto $proto from $from to $ipadr",
    default => "ufw allow proto $proto from $from to $ipadr port $port",
  },

  $unless  =  "$ipadr:$port" ? {
    'any:all'    => "ufw status | grep -E \" +ALLOW +$from_match\"",
    /[0-9]:all$/ => "ufw status | grep -E \"$ipadr/$proto +ALLOW +$from_match\"",
    /^any:[0-9]/ => "ufw status | grep -E \"$port/$proto +ALLOW +$from_match\"",
    default      => "ufw status | grep -E \"$ipadr $port/$proto +ALLOW +$from_match\"",
  },

  exec { "ufw-allow-${proto}-from-${from}-to-${ipadr}-port-${port}":
    command => $command,
    unless  => $unless,
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }
}
