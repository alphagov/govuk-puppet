define nagios::check_feature ($feature) {
  nagios::check_feature_w_prio { "check_feature_${feature}_high":
    feature   => $feature,
    prio      => 'high'
  }
  nagios::check_feature_w_prio { "check_feature_${feature}_medium":
    feature   => $feature,
    prio      => 'medium'
  }
  nagios::check_feature_w_prio { "check_feature_${feature}_low":
    feature   => $feature,
    prio      => 'low'
  }
  nagios::check_feature_w_prio { "check_feature_${feature}_unprio":
    feature   => $feature,
    prio      => 'unprio'
  }
}

define nagios::check_feature_w_prio ($feature, $prio) {
  nagios::check { "check_feature_${feature}_${prio}_checker":
    check_command       => "run_smokey_tests!${feature}!${prio}",
    use                 => "govuk_${prio}_priority",
    service_description => "Run ${feature} ${prio} priority tests",
    host_name           => "${::govuk_class}-${::hostname}"
  }
}

