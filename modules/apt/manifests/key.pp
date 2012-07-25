define apt::key(
  $ensure = 'present',
  $keyserver = 'keyserver.ubuntu.com'
) {
  exec { "apt-update-key-$name":
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
  }

  case $ensure {
    'present': {
      exec { "add_key_$name":
        command => "/usr/bin/apt-key adv --keyserver '${keyserver}' --recv '${name}'",
        unless  => "/usr/bin/apt-key list | grep -Fqe '${name}'",
        notify  => Exec["apt-update-key-${name}"];
      }
    }
    'absent': {
      exec { "rm_key_$name":
        command => "/usr/bin/apt-key del '${name}'",
        onlyif  => "/usr/bin/apt-key list | grep -Fqe '${name}'",
        notify  => Exec["apt-update-key-${name}"];
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for apt::key"
    }
  }
}
