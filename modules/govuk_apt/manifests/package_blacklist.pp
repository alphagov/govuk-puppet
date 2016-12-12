# == Class: Govuk_apt::Package_blacklist
#
# Blacklists specific packages from being able to be installed on the system.
# This will mean that even if a user tries to install a package use apt, the
# package specified will simply appear as unavailable for install.
#
# === Parameters:
#
#  [*packages*]
#    An array of packages that you wish to blacklist.
#
class govuk_apt::package_blacklist (
  $packages = [],
) {
  validate_array($packages)

  file { '/etc/apt/preferences':
    content => template('govuk_apt/preferences.erb'),
  }
}
