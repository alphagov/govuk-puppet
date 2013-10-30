# == Define: icinga::check_config::pingdom
#
# Create `icinga::check_config` entries for Pingdom checks. The
# `command_name` will take the form of:
#
#     run_pingdom_${title}_check
#
# === Parameters:
#
# [*check_id*]
#   ID of the check at Pingdom's side.
#
define icinga::check_config::pingdom(
  $check_id
) {
  icinga::check_config { "pingdom_${title}":
    content => template('icinga/check_pingdom.cfg.erb'),
  }
}
