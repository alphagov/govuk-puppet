# == Class: puppet::package
#
# Install packages for Puppet and various fixups that we require.
#
class puppet::package (
  $facter_version = '2.0.2-1puppetlabs1',
  $hiera_version = '1.3.4-1puppetlabs1',
  $puppet_version = '3.8.5-1puppetlabs1',
) {
  # Pin the desired Puppet version so that Puppet doesn't update
  # without us having tested the new version first. If Puppet breaks,
  # it won't be able to downgrade itself to the correct version.
  apt::pin { 'prevent_puppet_breakage':
    packages => 'puppet-common puppet',
    version  => $puppet_version,
    priority => 1001, # 1001 will cause a downgrade if necessary
  }
  apt::pin { 'prevent_facter_upgrade':
    packages => 'facter',
    version  => $facter_version,
    priority => 1001,
  }

  package { 'facter':
    ensure  => $facter_version,
    require => Apt::Pin['prevent_facter_upgrade'],
  }
  package { 'hiera':
    ensure => $hiera_version,
  }
  package { 'puppet':
    ensure  => $puppet_version,
    require => [
      Apt::Pin['prevent_puppet_breakage'],
      Package['facter', 'hiera'],
    ],
  }
  package { 'puppet-common':
    ensure  => $puppet_version,
    require => Package['puppet'],
  }

  unless $::lsbdistcodename == 'xenial' {
    # FIXME: Remove when we no longer bootstrap Vagrant and vCloud with gems.
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
  file { '/usr/local/bin/puppet':
    ensure  => absent,
    require => File['/usr/bin/puppet'],
  }
  file { '/usr/local/bin/facter':
    ensure  => absent,
    require => Package['facter'],
  }
}
