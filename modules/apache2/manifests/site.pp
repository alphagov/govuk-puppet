define apache2::site($content = 'UNSET', $source = 'UNSET') {

  if $content != 'UNSET' {
    file { "/etc/apache2/sites-available/$title":
      ensure  => present,
      require => Class['apache2::package'],
      notify  => Class['apache2::service'],
      content => $content,
    }
  } elsif $source != 'UNSET' {
    file { "/etc/apache2/sites-available/$title":
      ensure  => present,
      require => Class['apache2::package'],
      notify  => Class['apache2::service'],
      source  => $source,
    }
  } else {
    fail 'You must supply one of $content or $source to apache2::site'
  }

  file { "/etc/apache2/sites-enabled/$title":
    ensure  => link,
    target  => "/etc/apache2/sites-available/$title",
    require => [Class['apache2::package'], File["/etc/apache2/sites-available/$title"]],
    notify  => Class['apache2::service']
  }

}
