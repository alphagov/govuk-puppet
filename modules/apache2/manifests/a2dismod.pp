define apache2::a2dismod() {
  exec { "a2dismod $name":
    command => "/usr/sbin/a2dismod $name",
    onlyif  => "/bin/readlink -e /etc/apache2/mods-enabled/$name.load",
    require => Package['apache2'],
    notify  => Exec['apache_graceful'],
  }
}
