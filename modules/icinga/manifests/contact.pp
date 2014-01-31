define icinga::contact (
  $email,
  $service_notification_options = 'w,u,c,r',
  $notification_period          = '24x7'
) {

  $contact_email = $email

  file {"/etc/icinga/conf.d/contact_${name}.cfg":
    content => template('icinga/contact.cfg.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
