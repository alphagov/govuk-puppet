define icinga::pager_contact (
  $service_notification_options = 'w,u,c,r',
  $notification_period          = '24x7'
) {

  file {"/etc/icinga/conf.d/contact_${name}.cfg":
    content => template('icinga/pager_contact.cfg.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
