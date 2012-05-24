class ertp::scripts {
  file {'/etc/init/ertp.conf':
    ensure => present,
    source => ['puppet:///modules/ertp/ertp.conf']
  }

  file {'/etc/init/ertp-ems-admin.conf':
    ensure => present,
    source => ['puppet:///modules/ertp/ertp-ems-admin.conf']
  }
}

class ertp-api::scripts {
  file {'/etc/init/ertp-api.conf':
    ensure => present,
    source => ['puppet:///modules/ertp/ertp-api.conf']
  }
}
