define nagios::service_template () {
  file { "/etc/nagios3/conf.d/service_template_${name}.cfg":
    content => template('nagios/service_template.cfg.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
}