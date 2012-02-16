class logrotate {
  package { "logrotate":
    ensure => installed
  }

  file { "/etc/logrotate.d/apps":
    ensure  => present,
    source  => 'puppet:///modules/logrotate/apps',
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    require => Package['logrotate'],
  }
}
