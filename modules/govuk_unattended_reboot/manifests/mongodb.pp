# == Class: govuk_unattended_reboot::mongodb
#
# Installs a script which ensures that a MongoDB server
# can be rebooted.
#
# === Parameters
#
# [*enabled*]
#   Whether to enable the check for unattended reboots.
#
class govuk_unattended_reboot::mongodb (
  $enabled = false
) {

  $config_directory = '/etc/unattended-reboot'
  $check_scripts_directory = "${config_directory}/check"

  if ($enabled) {
    $file_ensure = present
  } else {
    $file_ensure = absent
  }

  file { "${check_scripts_directory}/02_mongodb.py":
    ensure  => $file_ensure,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/govuk_unattended_reboot/${check_scripts_directory}/02_mongodb.py",
    require => File[$check_scripts_directory],
  }
}
