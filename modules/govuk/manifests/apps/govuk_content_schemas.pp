# class: govuk::apps::govuk_content_schemas
#
# JSON schemas describing different types of content on GOV.UK.
#
# === Parameters
#
# [*directory*]
#   The directory in which the govuk_content_schemas should be
#   available.
#
class govuk::apps::govuk_content_schemas(
  $directory = '/data/apps/govuk-content-schemas/current',
) {
  include icinga::client::check_directory_exists

  @@icinga::check { "check_govuk_content_schemas_on_${::hostname}":
    check_command       => "check_nrpe!check_directory_exists!${directory}",
    service_description => 'govuk_content_schemas exists',
    host_name           => $::fqdn,
  }
}
