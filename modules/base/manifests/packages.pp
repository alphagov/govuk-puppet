# == Class: base::packages
#
# Installs common packages on a machine.
#
# === Parameters
#
# [*gems*]
#   A hash of gems to install.
#
# [*packages*]
#   An array of packages to install.
#
# [*ruby_version*]
#   Which version of the `ruby` package to install
#
# [*ensure_packages*]
#   The state of the base packages. 'absent' or 'present'
#
class base::packages (
  $gems = {},
  $packages = [],
  $ruby_version = installed,
  $ensure_packages = 'present',
) {
  validate_array($packages)

  ensure_packages($packages, { ensure => $ensure_packages })

  alternatives { 'editor':
    path    => '/usr/bin/vim.nox',
    require => Package['vim-nox'],
  }

  unless $::lsbdistcodename == 'xenial' {
    package { 'libruby1.9.1':
      ensure => $ruby_version,
    }

    package { 'ruby1.9.1-dev':
      ensure  => $ruby_version,
      require => Package['libruby1.9.1', 'ruby1.9.1'],
    }

    package { 'ruby1.9.1':
      ensure  => $ruby_version,
      require => Package['libruby1.9.1'],
    }
  }

  create_resources('package', $gems, { provider => 'gem' })

  # FIXME: Remove `alternatives` resource once we've stopped using Precise
  if $::lsbdistcodename == 'precise' {
    alternatives { 'ruby':
      path    => '/usr/bin/ruby1.9.1',
      require => Package['ruby1.9.1'],
    }
  }

  unless $::lsbdistcodename == 'precise' {
    package { 'python3-pip':
      ensure => 'latest',
    }
  }

  include nodejs
}
