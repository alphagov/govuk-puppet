# == Class: Govuk_apt::Package_blacklist
#
# Blacklists specific packages from being able to be installed on the system.
# This means, if a user tries to install a package using apt, the package
# specified will appear as unavailable for installation.
#
class govuk_apt::package_blacklist {
  unless $::lsbdistcodename == 'xenial' {
    apt::pin { 'blacklist_systemd':
      packages => 'systemd',
      priority => '-1',
      origin   => '""',
    }
  }
}
