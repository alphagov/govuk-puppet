class auditd::config {
  concat { '/etc/audit/audit.rules':
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
  }

  concat::fragment {'auditd_base_rules':
    target => '/etc/audit/audit.rules',
    source => 'puppet:///modules/auditd/etc/audit/audit.rules',
    order  => '01',
  }

  file { '/etc/audit/auditd.conf':
    ensure  => file,
    source  => 'puppet:///modules/auditd/etc/audit/auditd.conf',
    mode    => '0600',
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
