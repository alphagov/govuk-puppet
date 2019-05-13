# == Define: govuk::app::datagovuk_publish
#
# This is the publishing component of data.gov.uk
#
# === Parameters
#
# [*ensure*]
# allow govuk app to be removed.
#
# [*health_check_path*]
# path at which to check the status of the application.
#
# This is used to export health checks to ensure the application is running
# correctly.
#
# [*health_check_service_template*]
#   The title of a `Icinga::Service_template` from which the
#   healthcheck check should inherit.
#
# [*health_check_notification_period*]
#   The title of a `Icinga::Timeperiod` resource to be used by the
#   healthcheck.
#
# [*json_health_check*]
# whether the app's health check is exposed as JSON.
#
# Some of our apps are adopting a JSON-based healthcheck convention, where
# there is an overall `status` field that summarises the health of the app,
# and a `checks` dictionary with the results of individual app-level checks.
# Setting this to true will add a monitoring check that the healthcheck
# reports the app's status as OK.
#

class govuk::apps::datagovuk_publish {
  include icinga::client::check_json_healthcheck

  $port                             = 80
  $host                             = 'publish-data-beta.cloudapps.digital'
  $ensure                           = 'present'
  $title                            = 'datagovuk_publish'
  $healthcheck_desc                 = "${title} app healthcheck not ok"
  $healthcheck_opsmanual            = regsubst($healthcheck_desc, ' ', '-', 'G')
  $health_check_path                = '/healthcheck'
  $health_check_service_template    = 'govuk_regular_service'
  $health_check_notification_period = undef

  @@icinga::check { "check_app_${title}_healthcheck_on_${::hostname}":
    ensure              => $ensure,
    check_command       => "check_nrpe!check_json_healthcheck!${port} ${health_check_path} ${host}",
    service_description => $healthcheck_desc,
    use                 => $health_check_service_template,
    notification_period => $health_check_notification_period,
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url($healthcheck_opsmanual),
  }
}
