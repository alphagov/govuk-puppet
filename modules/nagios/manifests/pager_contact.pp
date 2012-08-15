define nagios::pager_contact (
  $service_notification_options = 'w,u,c,r',
  $notification_period          = '24x7'
) {

  file {"/etc/nagios3/conf.d/contact_${name}.cfg":
    content => template('nagios/pager_contact.cfg.erb'),
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }

}
