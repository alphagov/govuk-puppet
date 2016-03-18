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
# [*monitoring_basic_auth*]
#   A hash containing a `username` and a `password` to access monitoring
#   which is protected by basic authentication.
#
# [*lock_filenames*]
#   An array of filenames to check for locks on before allowing an unattended
#   reboot to take place.
class govuk_unattended_reboot (
  $enabled = false,
  $monitoring_basic_auth = {},
  $lock_filenames = ['/var/run/unattended-reboot.lock'],
) {

  validate_bool($enabled)
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

  file { "${check_scripts_directory}/00_lockfile":
    ensure  => $file_ensure,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template("govuk_unattended_reboot${check_scripts_directory}/00_lockfile.erb"),
  }

  file { "${check_scripts_directory}/01_alerts":
    ensure  => $file_ensure,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template("govuk_unattended_reboot${check_scripts_directory}/01_alerts.erb"),
    require => File['/usr/local/bin/check_icinga'],
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
    require                 => [
      File["${check_scripts_directory}/00_safety"],
      File["${check_scripts_directory}/00_lockfile"],
      File["${check_scripts_directory}/01_alerts"]
    ],
  }
}
