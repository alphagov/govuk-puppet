class logrotate {
  package { 'logrotate':
    ensure => installed
  }

  Logrotate::Conf <| |>
}
