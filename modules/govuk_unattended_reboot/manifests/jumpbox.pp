# == Class: govuk_unattended_reboot::jumpbox
#
# Installs a script which ensures that a jumpbox server
# can be rebooted.
#
class govuk_unattended_reboot::jumpbox (){
  $config_directory = '/etc/unattended-reboot'
  $check_scripts_directory = "${config_directory}/check"

  file { "${check_scripts_directory}/02_jumpbox":
    ensure  => 'present',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/govuk_unattended_reboot/${check_scripts_directory}/02_jumpbox",
    require => File[$check_scripts_directory],
  }
}
