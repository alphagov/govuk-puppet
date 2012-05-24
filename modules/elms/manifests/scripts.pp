class elms::scripts {
  file {'/etc/init/elms.conf':
    ensure => present,
    source => ['puppet:///modules/elms/elms.conf']
  }

  file {'/etc/init/elms-admin.conf':
    ensure => present,
    source => ['puppet:///modules/elms/elms-admin.conf']
  }
}
