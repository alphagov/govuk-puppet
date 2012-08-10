define nagios::timeperiod (
  $timeperiod_alias,
  $mon = undef,
  $tue = undef,
  $wed = undef,
  $thu = undef,
  $fri = undef,
  $sat = undef,
  $sun = undef
) {

  $timeperiod_name = $name

  file { "/etc/nagios3/conf.d/timeperiod_${name}.cfg":
    content => template('nagios/timeperiod.cfg.erb'),
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }

}
