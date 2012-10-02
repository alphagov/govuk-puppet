class ecryptfs {

  package { 'ecryptfs-utils':
    ensure => 'present',
  }

  file { '/usr/local/bin/govuk_ecryptfs_create':
    mode   => '0755',
    source => 'puppet:///modules/ecryptfs/govuk_ecryptfs_create',
  }

}
