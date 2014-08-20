# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class ecryptfs {

  package { 'ecryptfs-utils':
    ensure => 'present',
  }

  file { '/usr/local/bin/govuk_ecryptfs_create':
    mode   => '0755',
    source => 'puppet:///modules/ecryptfs/govuk_ecryptfs_create',
  }

}
