# == Class: govuk::apps::email_alert_api:checks
#
# Various Icinga checks for Email Alert API.
#
class govuk::apps::email_alert_api::checks {
  delivery_attempt_status_check { 'internal_failure': }
  delivery_attempt_status_check { 'technical_failure': }
}
