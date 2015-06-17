# == Class: govuk_unattended_reboot
#
# Coordinates unattended reboots of nodes across an environment,
# using a distributed mutex.
#
# === Parameters
#
# [*enabled*]
#   Whether to enable unattended reboots.
#   Default: false
#
class govuk_unattended_reboot (
  $enabled = false,
) {

  validate_bool($enabled)

  if ($enabled) {
    $file_ensure = present
    $directory_ensure = directory
  } else {
    $file_ensure = absent
    $directory_ensure = absent
  }

  $config_directory = '/etc/unattended-reboot'
  $check_scripts_directory = "${config_directory}/check"

  $node_class_search_phrase = regsubst($::govuk_node_class, '_', '-')
  $icinga_url = "https://nagios.cluster/cgi-bin/icinga/status.cgi?search_string=%5E${node_class_search_phrase}-[0-9]&allunhandledproblems&jsonoutput"

  file { '/usr/local/bin/check_icinga':
    ensure => $file_ensure,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/govuk_unattended_reboot/usr/local/bin/check_icinga.rb',
  } ->
  file { [ $config_directory, $check_scripts_directory ]:
    ensure => $directory_ensure,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  } ->
  file { "${check_scripts_directory}/00_safety":
    ensure  => $file_ensure,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template("govuk_unattended_reboot${check_scripts_directory}/00_safety.erb"),
  } ->
  file { "${check_scripts_directory}/01_alerts":
    ensure  => $file_ensure,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template("govuk_unattended_reboot${check_scripts_directory}/01_alerts.erb"),
  } ->
  class { '::unattended_reboot':
    enabled                 => $enabled,
    check_scripts_directory => $check_scripts_directory,
  }
}
