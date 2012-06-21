class elms::scripts {
  file {'/etc/init/elms.conf':
    ensure => present,
    source => ['puppet:///modules/elms/elms.conf']
  }

  file {'/etc/init/elms-admin.conf':
    ensure => present,
    source => ['puppet:///modules/elms/elms-admin.conf']
  }

  file {'/etc/init/licensify-feed.conf':
    ensure => present,
    source => ['puppet:///modules/elms/licensify-feed.conf']
  }

  file {'/etc/init/fake-adobe-lifecycle.conf':
    ensure => present,
    source => ['puppet:///modules/elms/fake-adobe-lifecycle.conf']
  }
}
