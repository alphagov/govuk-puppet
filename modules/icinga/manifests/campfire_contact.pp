define icinga::campfire_contact (
  $campfire_subdomain = 'undef',
  $campfire_token = 'undef',
  $campfire_room = 'undef'
) {

  file {"/etc/icinga/conf.d/contact_${name}.cfg":
    content => template('icinga/campfire_contact.cfg.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
