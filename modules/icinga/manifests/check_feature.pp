# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define icinga::check_feature(
  $feature,
  $ensure = present,
  $notes_url = undef
) {
  icinga::check_feature_w_prio { "check_feature_${feature}_normal":
    ensure    => $ensure,
    feature   => $feature,
    prio      => 'normal',
    notes_url => $notes_url,
  }
}
