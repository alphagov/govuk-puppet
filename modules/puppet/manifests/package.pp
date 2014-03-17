# == Class: puppet::package
#
# Install packages for Puppet and various fixups that we require.
#
class puppet::package (
  $facter_version = '1.7.2-1puppetlabs1',
  $puppet_version = '3.2.3-1puppetlabs1',
) {
  package { 'facter':
    ensure => $facter_version,
  }
  package { 'puppet-common':
    ensure  => $puppet_version,
    require => Package['facter'],
  }
  package { 'puppet':
    ensure  => $puppet_version,
    require => Package['puppet-common'],
  }

  # FIXME: Remove when we no longer bootstrap Vagrant and vCloud with gems.
  exec { 'remove_puppet_gem':
    command => '/usr/bin/gem uninstall --no-executables puppet',
    onlyif  => '/usr/bin/gem list -i puppet',
    require => Package['puppet-common'],
  }
  exec { 'remove_hiera_gem':
    command => '/usr/bin/gem uninstall --no-executables hiera',
    onlyif  => '/usr/bin/gem list -i hiera',
    require => Exec['remove_puppet_gem'],
  }
  exec { 'remove_facter_gem':
    command => '/usr/bin/gem uninstall --no-executables facter',
    onlyif  => '/usr/bin/gem list -i facter',
    require => Exec['remove_puppet_gem'],
  }

  # Pin the desired Puppet version so that Puppet doesn't update
  # without us having tested the new version first. If Puppet breaks,
  # it won't be able to downgrade itself to the correct version.
  apt::pin { 'prevent_puppet_breakage':
    packages   => 'puppet-common puppet',
    version    => $puppet_version,
    priority   => 1001, # 1001 will cause a downgrade if necessary
  }
  apt::pin { 'prevent_facter_upgrade':
    packages  => 'facter',
    version   => $facter_version,
    priority  => 1001,
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

  # This is required to allow Puppet to set the password hash for the ubuntu user
  # TODO: Provide this under different rbenv versions?
  package { 'libshadow':
    ensure   => present,
    provider => gem,
    require  => Package['build-essential'],
  }
}
