define nagios::contact (
  $email,
  $service_notification_options = 'w,u,c,r',
  $notification_period          = '24x7',
  $config_template              = 'nagios/contact.cfg.erb'
) {

  $contact_email = $email

  file {"/etc/nagios3/conf.d/contact_${name}.cfg":
    content => template($config_template),
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }

}
