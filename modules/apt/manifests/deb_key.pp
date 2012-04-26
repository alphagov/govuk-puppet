define apt::deb_key($keyserver='keyserver.ubuntu.com') {
  exec { "apt-update-key-$name":
    command     => '/usr/bin/apt-get update',
    refreshonly => true
  }
  exec { "add_key_$name":
    command => "/usr/bin/apt-key adv --keyserver $keyserver --recv $name",
    unless  => "apt-key list | grep -Fqe '${name}'",
    notify  => Exec["apt-update-key-$name"],
  }
}
