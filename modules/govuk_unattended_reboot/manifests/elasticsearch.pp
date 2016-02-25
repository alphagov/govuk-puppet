# == Class: govuk_unattended_reboot::elasticsearch
#
# Installs a script which ensures that an elasticsearch server
# can be rebooted.
#
# === Parameters
#
# [*enabled*]
#   Whether to enable the check for unattended reboots.
#
class govuk_unattended_reboot::elasticsearch (
  $enabled = false
) {

  $config_directory = '/etc/unattended-reboot'
  $check_scripts_directory = "${config_directory}/check"

  file { "${check_scripts_directory}/02_elasticsearch":
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/govuk_unattended_reboot/${check_scripts_directory}/02_elasticsearch",
    require => File[$check_scripts_directory],
  }

  # FIXME: Remove once deployed
  file { "${check_scripts_directory}/02_elasticsearch.py":
    ensure => absent,
  }
}
