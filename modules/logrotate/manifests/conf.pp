define logrotate::conf ($matches) {

  file { "/etc/logrotate.d/${title}":
    ensure  => present,
    content => template('logrotate/logrotate.conf.erb'),
    require => Package['logrotate'],
  }

}
