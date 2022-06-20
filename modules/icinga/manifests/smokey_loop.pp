# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define icinga::smokey_loop(
  $feature,
  $ensure = present,
  $notes_url = undef
) {
  $check_feature_name = regsubst($feature, '[^_a-z]', '', 'G')

  icinga::check { "smokey_loop_for_${check_feature_name}_${::hostname}":
    ensure              => $ensure,
    check_command       => "run_smokey_tests!${feature}",
    service_description => "Smokey loop for ${feature}",
    host_name           => $::fqdn,
    notes_url           => $notes_url,
  }
}
