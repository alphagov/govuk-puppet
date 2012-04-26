define apache2::a2ensite() {
  exec { "a2ensite $name":
    command => "/usr/sbin/a2ensite $name",
    unless  => "/bin/sh -c '[ -L /etc/apache2/sites-enabled/$name ] \\
      && [ /etc/apache2/sites-enabled/$name -ef /etc/apache2/sites-available/$name ]'",
    require => [
      Class['apache2::service'],
      File["/etc/apache2/sites-available/$name"]
    ],
    notify  => Exec['apache_graceful']
  }
}
