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
# [*etcd_endpoints*]
#   An array of 'hostname:port' etcd client endpoints.
#   Example: [ 'etcd-1.foo:4001', 'etcd-2.foo:4001', 'etcd-3.foo:4001' ]
#   Mandatory if enabled is set to `true`.
#
class govuk_unattended_reboot (
  $enabled = false,
  $etcd_endpoints = [],
) {

  validate_bool($enabled)
  validate_array($etcd_endpoints)

  if ($enabled) {
    $cron_ensure      = present
    $file_ensure      = present
    $pkg_ensure       = latest
    $logstream_ensure = present

    if empty($etcd_endpoints) {
      fail('Must pass non-empty array to govuk_unattended_reboot::etcd_endpoints')
    }
  } else {
    $cron_ensure      = absent
    $file_ensure      = absent
    $pkg_ensure       = purged
    $logstream_ensure = absent
  }

  $node_class_search_phrase = regsubst($::govuk_node_class, '_', '-')

  include logrotate

  # Upstart script to release reboot lock on boot
  file { '/etc/init/post-reboot-unlock.conf':
    ensure  => $file_ensure,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('govuk_unattended_reboot/post-reboot-unlock.erb'),
  } ->
  package { 'locksmithctl':
    ensure => $pkg_ensure,
  }

  # Check if a reboot is required every minute from midnight to 8am
  # and attempt to grab the reboot mutex.
  # Do this overnight only to prevent reboots during the day.
  cron { 'unattended-reboot':
    ensure      => $cron_ensure,
    hour        => '0-8',
    minute      => '*/5',
    user        => 'root',
    environment => ['MAILTO=""'],
    command     => '/usr/local/bin/unattended-reboot >> /var/log/unattended-reboot/unattended-reboot.log 2>&1',
    require     => Package['update-notifier-common'],
  } ->
  file { '/usr/local/bin/unattended-reboot':
    ensure  => $file_ensure,
    mode    => '0744',
    owner   => 'root',
    group   => 'root',
    require => Package['locksmithctl'],
    content => template('govuk_unattended_reboot/unattended-reboot.erb'),
  } ->
  file { '/usr/local/bin/check_icinga':
    ensure => $file_ensure,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/govuk_unattended_reboot/usr/local/bin/check_icinga.rb',
  } ->
  file { '/var/log/unattended-reboot':
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  govuk::logstream { 'unattended_reboot':
    ensure  => $logstream_ensure,
    fields  => {'application' => 'unattended-reboot'},
    logfile => '/var/log/unattended-reboot/unattended-reboot.log',
    tags    => ['unattended-reboot'],
  }

  file { '/etc/logrotate.d/unattended_reboot':
    ensure  => $file_ensure,
    source  => 'puppet:///modules/govuk_unattended_reboot/etc/logrotate.d/unattended_reboot',
    require => Class['logrotate'],
  }
}
