define logrotate::conf (
  $matches,
  $days_to_keep = '365'
) {

  file { "/etc/logrotate.d/${title}":
    ensure  => present,
    content => template('logrotate/logrotate.conf.erb'),
    require => Package['logrotate'],
  }

}
