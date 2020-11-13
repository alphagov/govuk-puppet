# == Class: govuk::apps::prometheus
#
# === Parameters
# [*port*]
#   What port should the app run on?
#
# [*enabled*]
#   Whether to install or uninstall the app. Defaults to true (install on all enviroments)
#
class govuk::apps::prometheus (
  $port = 9090,
  $enabled = false,
) {
  $app_name = 'prometheus'

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }
}
