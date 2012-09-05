class auditd::service {
  service { 'auditd':
      ensure  => running,
      require => Class['auditd::package']
  }
}
