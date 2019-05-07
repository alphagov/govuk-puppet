# == Class: govuk_unattended_reboot::elasticsearch
#
# Installs a script which ensures that an elasticsearch server
# can be rebooted.
#
class govuk_unattended_reboot::elasticsearch (
) {

  $config_directory = '/etc/unattended-reboot'
  $check_scripts_directory = "${config_directory}/check"

  file { "${check_scripts_directory}/02_elasticsearch":
    ensure  => 'absent',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/govuk_unattended_reboot/${check_scripts_directory}/02_elasticsearch",
    require => File[$check_scripts_directory],
  }

}
