# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define icinga::check_feature ($feature) {
  icinga::check_feature_w_prio { "check_feature_${feature}_urgent":
    feature   => $feature,
    prio      => 'urgent',
  }
  icinga::check_feature_w_prio { "check_feature_${feature}_high":
    feature   => $feature,
    prio      => 'high',
  }
  icinga::check_feature_w_prio { "check_feature_${feature}_normal":
    feature   => $feature,
    prio      => 'normal',
  }
  icinga::check_feature_w_prio { "check_feature_${feature}_low":
    feature   => $feature,
    prio      => 'low',
  }
}
