class auditd::package {
  package { 'auditd':
    ensure => installed
  }
  package { 'libaudit0':
    ensure => installed
  }
  package { 'audispd-plugins':
    ensure => installed
  }
}
