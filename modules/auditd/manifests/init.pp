class auditd {

  anchor { 'auditd::begin':
    before => Class['auditd::package'],
    notify => Class['auditd::service'];
  }

  class { 'auditd::package':
    notify => Class['auditd::service'];
  }

  class { 'auditd::config':
    require => Class['auditd::package'],
    notify  => Class['auditd::service'];
  }

  class { 'auditd::service': }

  anchor { 'auditd::end':
    require => Class['auditd::service'],
  }
}
