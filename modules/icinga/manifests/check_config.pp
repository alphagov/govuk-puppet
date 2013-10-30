# == Define: icinga::check_config
#
# Create the configuration for a new Nagios `check_command`.
#
# === Parameters:
#
# [*content*]
#   Content of the check config.
#
# [*source*]
#   File source of the check config.
#
define icinga::check_config (
  $content = undef,
  $source = undef
) {

  file { "/etc/icinga/conf.d/check_${title}.cfg":
    ensure  => present,
    content => $content,
    source  => $source,
    require => Class['icinga::client::package'],
    notify  => Class['icinga::client::service'],
  }

}
