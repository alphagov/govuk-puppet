define icinga::check_feature ($feature, $notes_url = undef) {
  icinga::check_feature_w_prio { "check_feature_${feature}_urgent":
    feature   => $feature,
    prio      => 'urgent',
    notes_url => $notes_url,
  }
  icinga::check_feature_w_prio { "check_feature_${feature}_high":
    feature   => $feature,
    prio      => 'high',
    notes_url => $notes_url,
  }
  icinga::check_feature_w_prio { "check_feature_${feature}_normal":
    feature   => $feature,
    prio      => 'normal',
    notes_url => $notes_url,
  }
  icinga::check_feature_w_prio { "check_feature_${feature}_low":
    feature   => $feature,
    prio      => 'low',
    notes_url => $notes_url,
  }
}

define icinga::check_feature_w_prio ($feature, $prio, $notes_url) {
  icinga::check { "check_feature_${feature}_${prio}_checker":
    check_command       => "run_smokey_tests!${feature}!${prio}",
    use                 => "govuk_${prio}_priority",
    service_description => "Run ${feature} ${prio} priority tests",
    host_name           => $::fqdn,
    notes_url           => $notes_url,
  }
}

