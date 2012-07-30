define nagios::timeperiod (
  $timeperiod_alias,
  $mon    = undef,
  $tue    = undef,
  $wed    = undef,
  $thu    = undef,
  $fri    = undef,
  $sat    = undef,
  $sun    = undef ) {
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
