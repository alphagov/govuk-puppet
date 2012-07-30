define nagios::contact_group ($group_alias, $members) {
  $group_name = $name
  $group_members = $members
  file { "/etc/nagios3/conf.d/contact_group_${name}.cfg":
    content => template('nagios/contact_group.cfg.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[nagios3],
    require => Package[nagios3],
  }
}
