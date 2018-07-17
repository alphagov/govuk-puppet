# == Class: puppet::package
#
# Install packages for Puppet and various fixups that we require.
#
class puppet::package {
  # Ensure latest as there will not be another release on the 3.x series.
  # 4.x and 5.x are only available through a different set of Debian repos,
  # and the package naming scheme also differs.
  package { ['puppet-common', 'puppet', 'hiera', 'facter']:
    ensure => latest,
  }

  if $::puppet::gem_bootstrap {
    # FIXME: Remove when we no longer bootstrap vCloud with gems.
    warning('Deprecation warning: Removing Gem-installed Puppet due to $::puppet::gem_bootstrap == true.')

    exec { 'remove_puppet_gem':
      command => '/usr/bin/gem uninstall --all --no-executables puppet',
      onlyif  => '/usr/bin/gem list -i \'^puppet$\'',
      require => Package['puppet-common'],
    }

    exec { 'remove_hiera_gem':
      command => '/usr/bin/gem uninstall --all --no-executables hiera',
      onlyif  => '/usr/bin/gem list -i \'^hiera$\'',
      require => Exec['remove_puppet_gem'],
    }

    exec { 'remove_facter_gem':
      command => '/usr/bin/gem uninstall --all --no-executables facter',
      onlyif  => '/usr/bin/gem list -i \'^facter$\'',
      require => Exec['remove_puppet_gem'],
    }
  }

  file { '/usr/bin/puppet':
    ensure  => present,
    source  => 'puppet:///modules/puppet/usr/bin/puppet',
    mode    => '0755',
    require => Package['puppet-common'],
  }

  # Not sure if these are still needed or not but will definitely go away
  # with the Puppet 5 upgrade
  file { '/usr/local/bin/puppet':
    ensure  => absent,
    require => File['/usr/bin/puppet'],
  }

  file { '/usr/local/bin/facter':
    ensure  => absent,
    require => Package['facter'],
  }
}
