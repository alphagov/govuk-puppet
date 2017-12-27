# == Class: icinga::config::smokey
#
# Set up smoke tests to run from within Icinga
#
class icinga::config::smokey {
  file { '/etc/icinga/conf.d/check_smokey.cfg':
    source => 'puppet:///modules/icinga/etc/icinga/conf.d/check_smokey.cfg',
  }
}
