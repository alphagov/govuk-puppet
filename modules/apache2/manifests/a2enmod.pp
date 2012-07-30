define apache2::a2enmod() {
  exec { "a2enmod $name":
    command => "/usr/sbin/a2enmod $name",
    unless  => "/bin/sh -c '[ -L /etc/apache2/mods-enabled/$name.load ] \\
      && [ /etc/apache2/mods-enabled/$name.load -ef /etc/apache2/mods-available/$name.load ]'",
    require => Class['apache2::package'],
    notify  => Class['apache2::service'],
  }
}
