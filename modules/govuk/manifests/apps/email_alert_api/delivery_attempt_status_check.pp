# == Define: govuk::apps::email_alert_api::delivery_attempt_status_check
#
# Creates an Icinga check which checks Graphite for high numbers of delivery
# attempts with a specifc status.
#
# === Parameters
#
# [*ensure*]
#   Whether to enable the check.
#   Default: present
#
# [*title*]
#   The status of the delivery attempts to look for.
#
define govuk::apps::email_alert_api::delivery_attempt_status_check(
  $ensure = present,
) {
  @@icinga::check::graphite { "email-alert-api-delivery-attempt-${title}":
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => "sum(stats.govuk.app.email-alert-api.*.delivery_attempt.status.${title})",
    warning   => '0.5',
    critical  => '1',
    from      => '1hour',
    desc      => "High number of ${title} delivery attempts",
    notes_url => monitoring_docs_url(email-alert-api-delivery-attempt-status),
  }
}
