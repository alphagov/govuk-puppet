define apt::key(
  $ensure = 'present',
  $keyserver = 'hkp://keyserver.ubuntu.com:80'
) {

  case $ensure {
    'present': {
      exec { "add_key_$name":
        command => "/usr/bin/apt-key adv --keyserver '${keyserver}' --recv '${name}'",
        unless  => "/usr/bin/apt-key list | grep -Fqe '${name}'",
        require => Class['apt'],
        notify  => Class['apt::update'],
      }
    }
    'absent': {
      exec { "rm_key_$name":
        command => "/usr/bin/apt-key del '${name}'",
        onlyif  => "/usr/bin/apt-key list | grep -Fqe '${name}'",
        require => Class['apt'],
        notify  => Class['apt::update'],
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for apt::key"
    }
  }
}
