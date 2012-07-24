define nagios::timeperiod (
  $timeperiod_alias,
  $mon    = '',
  $tue    = '',
  $wed    = '',
  $thu    = '',
  $fri    = '',
  $sat    = '',
  $sun    = '' ) {
    $timeperiod_name = $name
    file { "/etc/nagios3/conf.d/timeperiod_${name}.cfg":
      content => template('nagios/timeperiod.cfg.erb'),
      owner   => root,
      group   => root,
      mode    => '0644',
      notify  => Service[nagios3],
      require => Package[nagios3],
    }
}
