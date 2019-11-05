# == Class: govuk::apps::email_alert_api:checks
#
# Various Icinga checks for Email Alert API.
#
class govuk::apps::email_alert_api::checks(
  $internal_failure = true,
  $technical_failure = true,
) {
  $internal_failure_ensure = $internal_failure ? { true => present, false => absent }

  delivery_attempt_status_check { 'internal_failure':
    ensure => $internal_failure_ensure,
  }

  $technical_failure_ensure = $technical_failure ? { true => present, false => absent }

  delivery_attempt_status_check { 'technical_failure':
    ensure => $technical_failure_ensure,
  }
}
