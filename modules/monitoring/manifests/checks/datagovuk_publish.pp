# == Class: monitoring::checks::datagovuk_publish
#
# Icinga checks for the publishing component of data.gov.uk
#
# === Parameters
#
# [*ensure*]
#   Ensure value to pass to the Icinga check.
#
# [*host*]
#   Host to check the healthcheck for.
#
#
class monitoring::checks::datagovuk_publish(
  $ensure = 'absent',
  $host   = undef,
  $protocol = 'https'
) {
  include icinga::client::check_json_healthcheck

  $port                             = 80
  $healthcheck_desc                 = 'data.gov.uk publish healthcheck not ok'
  $healthcheck_opsmanual            = regsubst($healthcheck_desc, ' ', '-', 'G')
  $health_check_path                = '/healthcheck'

  @@icinga::check { 'check_datagovuk_publish_healthcheck':
    ensure              => $ensure,
    check_command       => "check_app_health!check_json_healthcheck!${port} ${health_check_path} ${host} ${protocol}",
    service_description => $healthcheck_desc,
    use                 => 'govuk_regular_service',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url($healthcheck_opsmanual),
  }
}
