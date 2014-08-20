# Checks a feature at a certain priority
define icinga::check_feature_w_prio ($feature, $prio, $notes_url) {
  icinga::check { "check_feature_${feature}_${prio}_checker":
    check_command       => "run_smokey_tests!${feature}!${prio}",
    use                 => "govuk_${prio}_priority",
    service_description => "Run ${feature} ${prio} priority tests",
    host_name           => $::fqdn,
    notes_url           => $notes_url,
  }
}
