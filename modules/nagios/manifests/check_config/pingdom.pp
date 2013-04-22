# == Define: nagios::check_config::pingdom
#
# Create `nagios::check_config` entries for Pingdom checks. The
# `command_name` will take the form of:
#
#     run_pingdom_${title}_check
#
# === Parameters:
#
# [*check_id*]
#   ID of the check at Pingdom's side.
#
define nagios::check_config::pingdom(
  $check_id
) {
  nagios::check_config { "pingdom_${title}":
    content => template('nagios/etc/nagios3/conf.d/check_pingdom.cfg.erb'),
  }
}
