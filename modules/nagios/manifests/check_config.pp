# == Define: nagios::check_config
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
define nagios::check_config (
  $content = undef,
  $source = undef
) {

  file { "/etc/nagios3/conf.d/check_${title}.cfg":
    ensure  => present,
    content => $content,
    source  => $source,
    require => Class['nagios::client::package'],
    notify  => Class['nagios::client::service'],
  }

}
