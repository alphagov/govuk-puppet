class auditd::config {
  file { '/etc/audit/audit.rules':
    ensure  => file,
    source  => 'puppet:///modules/auditd/etc/audit/audit.rules',
    mode    => '0620',
    owner   => 'root',
    group   => 'root',
    require => Package['auditd']
  }
  file { '/etc/audit/auditd.conf':
    ensure  => file,
    source  => 'puppet:///modules/auditd/etc/audit/auditd.conf',
    mode    => '0620',
    owner   => 'root',
    group   => 'root',
    require => Package['auditd']
  }
  file { '/sbin/audispd':
    mode  => '0750',
    owner => 'root',
    group => 'root',
  }
}
