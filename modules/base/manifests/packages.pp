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
class base::packages (
  $gems = {},
  $packages = [],
  $ruby_version = installed,
) {
  validate_array($packages)

  ensure_packages($packages)

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

  include nodejs
}
