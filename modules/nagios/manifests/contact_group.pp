define nagios::contact_group ($group_alias, $members) {

  $group_name = $name
  $group_members = $members

  file { "/etc/nagios3/conf.d/contact_group_${name}.cfg":
    content => template('nagios/contact_group.cfg.erb'),
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }

}
