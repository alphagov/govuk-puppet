# == Define: govuk::mount
#
# Wrapper for `Ext4mount[]` which will automatically setup new Nagios checks
# for free space and inodes.
#
# === Parameters
#
# [*no_op*]
#   If `true` the mount won't actually be created/action. This can be used for
#   localised VMs (e.g. Vagrant) which don't have additional storage
#   attached, so as not to change/break the relationships of other resources
#   that depend on the volume.
#   Default: `false`
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
# [*govuk_lvm*]
#   If you're using govuk::lvm to create a logical volume pass the title so
#   that it gets run before the ext4mount.
#
# See the ext4mount module/define for all other parameters. They are defined
# as `undef` here so that upstream defaults are respected, except for
# `mountpoint` which needs to default to `$title`.
#
define govuk::mount(
  $no_op = false,
  $nagios_warn = 10,
  $nagios_crit = 5,
  $govuk_lvm = undef,
  # Ext4mount[] options (I long for **kwargs)
  $disk = undef,
  $mountoptions = undef,
  $mountpoint = $title
) {
  $mountpoint_escaped = regsubst($mountpoint, '/', '_', 'G')

  unless $no_op {
    if $govuk_lvm != undef {
      Govuk::Lvm[$govuk_lvm] -> Ext4mount[$title]
    }

    ext4mount { $title:
      disk         => $disk,
      mountoptions => $mountoptions,
      mountpoint   => $mountpoint,
    }
  }

  @@icinga::check { "check${mountpoint_escaped}_disk_space_${::hostname}":
    check_command       => "check_nrpe!check_disk_space_arg!${nagios_warn}% ${nagios_crit}% ${mountpoint}",
    service_description => "low available disk space on ${mountpoint}",
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-space',
  }

  @@icinga::check { "check${mountpoint_escaped}_disk_inodes_${::hostname}":
    check_command       => "check_nrpe!check_disk_inodes_arg!${nagios_warn}% ${nagios_crit}% ${mountpoint}",
    service_description => "low available disk inodes on ${mountpoint}",
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-inodes',
  }
}
