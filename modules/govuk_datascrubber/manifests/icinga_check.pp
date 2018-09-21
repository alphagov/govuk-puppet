# == Define: govuk_datascrubber::icinga_check
#
# Create Icinga passive checks for scrubber tasks
#
define govuk_datascrubber::icinga_check {
  $check_title = "datascrubber-${title}"
  $service_desc = "GOV.UK data scrubber ${title}"
  $threshold_secs = 28 * 3600

  @@icinga::passive_check { $check_title :
    service_description => $service_desc,
    freshness_threshold => $threshold_secs,
    host_name           => $::fqdn,
  }
}
