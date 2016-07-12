# == Class: postfix::package
#
# Manage the postfix package
#
class postfix::package {
  package { 'postfix':
    ensure => installed,
  }
}
