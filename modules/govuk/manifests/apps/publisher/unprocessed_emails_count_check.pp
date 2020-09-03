# == Define: govuk::apps::publisher::unprocessed_emails_count_check
#
# Creates an Icinga check which checks Graphite for the number of unprocessed
# fact-check emails.
#
# === Parameters
#
# [*ensure*]
#   Whether to enable the check.
#   Default: present
#
class govuk::apps::publisher::unprocessed_emails_count_check(
  $ensure = present,
) {
  @@icinga::check::graphite { 'check_publisher_unprocessed_fact_check_emails':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(averageSeries(keepLastValue(stats.gauges.govuk.app.publisher.*.unprocessed_emails.count)))',
    warning   => '1',
    critical  => '2',
    from      => '1hour',
    desc      => 'publisher - unprocessed fact-check emails are present',
    notes_url => monitoring_docs_url(publisher-unprocessed-fact-check-emails),
  }
}
