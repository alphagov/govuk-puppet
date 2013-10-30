define icinga::contact_group ($group_alias, $members) {

  $group_name = $name
  $group_members = $members

  file { "/etc/icinga/conf.d/contact_group_${name}.cfg":
    content => template('icinga/contact_group.cfg.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
