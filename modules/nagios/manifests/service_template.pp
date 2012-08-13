define nagios::service_template ($contact_groups) {

  file { "/etc/nagios3/conf.d/service_template_${name}.cfg":
    content => template('nagios/service_template.cfg.erb'),
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }

}
