define nagios::contact (
  $email,
  $service_notification_options = 'w,u,c,r'
) {
  $contact_email = $email
  file {"/etc/nagios3/conf.d/contact_${name}.cfg":
    content => template('nagios/contact.cfg.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
}
