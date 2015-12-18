# == Class: nsca
#
# Installs the nsca package.
#
class nsca {
  package {'nsca':
    ensure => installed,
  }
}
