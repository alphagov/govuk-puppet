# == Class: postfix::package
#
# Manage the postfix package
#
class postfix::package($ensure = installed) {
  package { 'postfix':
    ensure  => $ensure,
  }
}
