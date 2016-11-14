# == Define: icinga::check_feature
#
# Create the configuration for a new Icinga `check_feature`.
#
# === Parameters
#
# [*feature*]
#   Name of the feature to be created.
#
# [*notes_url*]
#   URL to show in Icinga for further information about this check
#   Default: undef
#
# [*enabled*]
#   Can be used to disable checks/alerts for a given environment.
#   Default: true
#
define icinga::check_feature ($feature, $notes_url = undef, $enabled = true) {
  if $enabled {
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
}

