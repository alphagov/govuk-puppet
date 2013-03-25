class logrotate {
  package { 'logrotate':
    ensure => installed
  }

  #TODO: this is workaround for issues with lucid.
  if $::operatingsystemrelease == '10.04' {
    file { "/etc/logrotate.d/rsyslog":
      ensure  => present,
      source  => 'puppet:///modules/logrotate/rsyslog',
      require => Package['logrotate'],
    }
  }

  Logrotate::Conf <| |>
}
