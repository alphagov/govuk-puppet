# == Define: icinga::contact_group
#
# Create the configuration for the named contact group and its members
#
# === Parameters
#
# [*group_alias*]
#   A free form string describing this contact group.
#
# [*members*]
#   An array of members that should be in this contact group.
#
define icinga::contact_group ($group_alias, $members) {

  $group_name = $name
  $group_members = $members

  file { "/etc/icinga/conf.d/contact_group_${name}.cfg":
    content => template('icinga/contact_group.cfg.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
