# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define icinga::timeperiod (
  $timeperiod_alias,
  $mon = undef,
  $tue = undef,
  $wed = undef,
  $thu = undef,
  $fri = undef,
  $sat = undef,
  $sun = undef
) {

  $timeperiod_name = $name

  file { "/etc/icinga/conf.d/timeperiod_${name}.cfg":
    content => template('icinga/timeperiod.cfg.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
