# == Class libffi
class libffi {
  package { 'libffi-dev':
    ensure => present,
  }
}
