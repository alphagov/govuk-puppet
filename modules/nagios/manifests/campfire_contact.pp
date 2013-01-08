define nagios::campfire_contact (
  $campfire_subdomain = 'undef',
  $campfire_token = 'undef',
  $campfire_room = 'undef'
) {

  file {"/etc/nagios3/conf.d/contact_${name}.cfg":
    content => template('nagios/campfire_contact.cfg.erb'),
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }

}
