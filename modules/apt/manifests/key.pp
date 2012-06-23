define apt::key($apt_key_url, $ensure='present') {
  case $ensure {
    'present': {
      exec { "apt-key present $name":
        command => "/usr/bin/wget -q $apt_key_url/$name -O -|/usr/bin/apt-key add -",
        unless  => "/usr/bin/apt-key list|/bin/grep -c '$name'",
        before  => Exec['apt_update']
      }
    }
    'absent': {
      exec { "apt-key absent $name":
        command => "/usr/bin/apt-key del '$name'",
        onlyif  => "/usr/bin/apt-key list|/bin/grep -c '$name'",
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for apt::key"
    }
  }
}
