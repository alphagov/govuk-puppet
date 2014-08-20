# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define icinga::contact_group ($group_alias, $members) {

  $group_name = $name
  $group_members = $members

  file { "/etc/icinga/conf.d/contact_group_${name}.cfg":
    content => template('icinga/contact_group.cfg.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
