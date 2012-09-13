define ganglia::pymod_alias ( $target ) {

  file { "/usr/lib/ganglia/python_modules/${title}.py":
    ensure  => link,
    target  => "/usr/lib/ganglia/python_modules/${target}.py",
    require => Class['ganglia::client::package'],
    notify  => Class['ganglia::client::service'],
  }

}
