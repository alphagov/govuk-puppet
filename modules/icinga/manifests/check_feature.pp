define icinga::check_feature ($feature) {
  icinga::check_feature_w_prio { "check_feature_${feature}_urgent":
    feature   => $feature,
    prio      => 'urgent'
  }
  icinga::check_feature_w_prio { "check_feature_${feature}_high":
    feature   => $feature,
    prio      => 'high'
  }
  icinga::check_feature_w_prio { "check_feature_${feature}_normal":
    feature   => $feature,
    prio      => 'normal'
  }
  icinga::check_feature_w_prio { "check_feature_${feature}_low":
    feature   => $feature,
    prio      => 'low'
  }
}

define icinga::check_feature_w_prio ($feature, $prio) {
  icinga::check { "check_feature_${feature}_${prio}_checker":
    check_command       => "run_smokey_tests!${feature}!${prio}",
    use                 => "govuk_${prio}_priority",
    service_description => "Run ${feature} ${prio} priority tests",
    host_name           => $::fqdn,
  }
}

