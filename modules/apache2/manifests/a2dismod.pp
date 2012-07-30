define apache2::a2dismod() {
  exec { "a2dismod $name":
    command => "/usr/sbin/a2dismod $name",
    onlyif  => "/bin/readlink -e /etc/apache2/mods-enabled/$name.load",
    require => Class['apache2::package'],
    notify  => Class['apache2::service'],
  }
}
