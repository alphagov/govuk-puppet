# == Class: govuk_unattended_reboot::mongodb
#
# Installs a script which ensures that a MongoDB server
# can be rebooted.
#
class govuk_unattended_reboot::mongodb {

  $config_directory = '/etc/unattended-reboot'
  $check_scripts_directory = "${config_directory}/check"

  file { "${check_scripts_directory}/02_mongodb.py":
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/govuk_unattended_reboot/${check_scripts_directory}/02_mongodb.py",
    require => File[$check_scripts_directory],
  }
}
