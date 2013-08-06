# == Define: govuk::mount
#
# Wrapper for `Ext4mount[]` which will automatically setup new Nagios checks
# for free space and inodes.
#
# It will not create a real `Ext4mount[]` resource for some values of Puppet
# `$::environment` where additional disks cannot be attached - ie. Vagrant
#
# === Parameters
#
# [*nagios_warn*]
#   Percentage at which Nagios will raise a WARNING alert for free space and
#   inodes.
#   Default: 10
#
# [*nagios_crit*]
#   Percentage at which Nagios will raise a CRITICAL alert for free space and
#   inodes.
#   Default: 20
#
# See the ext4mount module/define for all other parameters. They are defined
# as `undef` here so that upstream defaults are respected, except for
# `mountpoint` which needs to default to `$title`.
#
define govuk::mount(
  $nagios_warn = 20,
  $nagios_crit = 10,
  # Ext4mount[] options (I long for **kwargs)
  $disk = undef,
  $mountoptions = undef,
  $mountpoint = $title
) {
  $mountpoint_escaped = regsubst($mountpoint, '/', '_', 'G')
  $exclude_environments = ['vagrant']

  unless $::environment in $exclude_environments {
    ext4mount { $title:
      disk         => $disk,
      mountoptions => $mountoptions,
      mountpoint   => $mountpoint,
    }
  }

  @@nagios::check { "check${mountpoint_escaped}_disk_space_${::hostname}":
    check_command       => "check_nrpe!check_disk_space_arg!${nagios_warn}% ${nagios_crit}% ${mountpoint}",
    service_description => "low available disk space on ${mountpoint}",
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-space',
  }

  @@nagios::check { "check${mountpoint_escaped}_disk_inodes_${::hostname}":
    check_command       => "check_nrpe!check_disk_inodes_arg!${nagios_warn}% ${nagios_crit}% ${mountpoint}",
    service_description => "low available disk inodes on ${mountpoint}",
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-inodes',
  }
}
