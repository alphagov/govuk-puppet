# class: govuk::apps::govuk_content_schemas
#
# JSON schemas describing different types of content on GOV.UK.
#
# === Parameters
#
# [*ensure*]
#   Allow schemas to be removed.
#
# [*directory*]
#   The directory in which the govuk_content_schemas should be
#   deployed.
#
class govuk::apps::govuk_content_schemas(
  $ensure = present,
  $directory = '/data/apps/govuk-content-schemas',
) {
  include icinga::client::check_directory_exists

  if $ensure == absent {
    file { $directory:
      ensure => absent,
      force  => true,
    }
  }

  $current_directory = "${directory}/current"

  @@icinga::check { "check_govuk_content_schemas_on_${::hostname}":
    ensure              => $ensure,
    check_command       => "check_nrpe!check_directory_exists!${current_directory}",
    service_description => 'govuk_content_schemas exists',
    host_name           => $::fqdn,
  }
}
