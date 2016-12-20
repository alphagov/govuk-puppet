# == Define: icinga::check
#
# Checks a feature at a certain priority
#
# === Parameters:
#
# [*feature*]
#
# [*prio*]
#
# [*notes_url*]
#   Documentation URL for more information about how to diagnose the service
#   and why the alert might exist. Should link to a section of the
#   "opsmanual". This will be included in the Nagios UI and email alerts.
#
define icinga::check_feature_w_prio (
  $feature,
  $prio,
  $notes_url = undef,
) {
  icinga::check { "check_feature_${feature}_${prio}_checker":
    check_command       => "run_smokey_tests!${feature}!${prio}",
    use                 => "govuk_${prio}_priority",
    service_description => "Run ${feature} ${prio} priority tests",
    host_name           => $::fqdn,
    notes_url           => $notes_url,
  }
}
