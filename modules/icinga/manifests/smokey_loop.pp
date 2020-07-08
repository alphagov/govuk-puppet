# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define icinga::smokey_loop(
  $feature,
  $ensure = present,
  $notes_url = undef
) {
  icinga::check { "smokey_loop_for_${feature}":
    ensure              => $ensure,
    check_command       => "run_smokey_tests!${feature}",
    service_description => "Smokey loop for ${feature}",
    host_name           => $::fqdn,
    notes_url           => $notes_url,
  }
}
