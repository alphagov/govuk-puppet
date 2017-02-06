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
# [*manage_repo_class*]
#   Whether to use a separate repository to install Locksmith
#   Default: false (use 'govuk_ppa' repository)
#
# [*monitoring_basic_auth*]
#   A hash containing a `username` and a `password` to access monitoring
#   which is protected by basic authentication.
#
# === Variables
#
# [*lock_dir*]
#   path => /etc/unattended-reboot/no-reboot/
#   The directory in which a process places a file while in progress to
#   prevent the host from rebooting.
#
class govuk_unattended_reboot (
  $enabled = false,
  $manage_repo_class = false,
  $monitoring_basic_auth = {},
) {

  validate_bool($enabled)
  validate_bool($manage_repo_class)
  validate_hash($monitoring_basic_auth)

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
  $icinga_url = "https://alert.cluster/cgi-bin/icinga/status.cgi?search_string=%5E${node_class_search_phrase}-[0-9]&allunhandledproblems&jsonoutput"

  if $manage_repo_class {
    include govuk_unattended_reboot::repo
  }

  file { [ $config_directory, $check_scripts_directory ]:
    ensure => $directory_ensure,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { "${check_scripts_directory}/00_safety":
    ensure  => $file_ensure,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template("govuk_unattended_reboot${check_scripts_directory}/00_safety.erb"),
  }

  file { "${check_scripts_directory}/01_alerts":
    ensure  => $file_ensure,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template("govuk_unattended_reboot${check_scripts_directory}/01_alerts.erb"),
    require => File['/usr/local/bin/check_icinga'],
  }

  $lock_dir = "${config_directory}/no-reboot"

  file { $lock_dir:
    ensure => $directory_ensure,
    mode   => '0777',
    owner  => 'root',
    group  => 'root',
  }

  file { '03_no_reboot':
    ensure  => $file_ensure,
    path    => "${check_scripts_directory}/03_no_reboot",
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('govuk_unattended_reboot/03_no_reboot.erb'),
  }

  file { '/usr/local/bin/check_icinga':
    ensure => $file_ensure,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/govuk_unattended_reboot/usr/local/bin/check_icinga.rb',
  }

  class { '::unattended_reboot':
    enabled                 => $enabled,
    check_scripts_directory => $check_scripts_directory,
    require                 => [ File["${check_scripts_directory}/00_safety"], File["${check_scripts_directory}/01_alerts"] ],
  }
}
