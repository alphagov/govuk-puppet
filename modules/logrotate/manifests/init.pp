# == Class: logrotate
#
# Installs the logrotate package.
#
class logrotate {
  package { 'logrotate':
    ensure => installed
  }

  Logrotate::Conf <| |>
}
