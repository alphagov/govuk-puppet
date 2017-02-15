# == Define: govuk_mount
#
# Wrapper for `Ext4mount[]` which will automatically setup new monitoring checks
# for free space and inodes.
#
# === Parameters
#
# [*percent_threshold_warning*]
#   Percentage at which monitoring will raise a WARNING alert for free space and
#   inodes.
#   Default: 10
#
# [*percent_threshold_critical*]
#   Percentage at which monitoring will raise a CRITICAL alert for free space and
#   inodes.
#   Default: 5
#
# [*govuk_lvm*]
#   If you're using govuk_lvm to create a logical volume pass the title so
#   that it gets run before the ext4mount.
#
# See the ext4mount module/define for all other parameters. They are defined
# as `undef` here so that upstream defaults are respected, except for
# `mountpoint` which needs to default to `$title`.
#
define govuk_mount(
  $percent_threshold_warning = 10,
  $percent_threshold_critical = 5,
  $govuk_lvm = undef,
  # Ext4mount[] options (I long for **kwargs)
  $disk = undef,
  $mountoptions = undef,
  $mountpoint = $title
) {
  $app_domain = hiera('app_domain')
  $mountpoint_escaped = regsubst($mountpoint, '/', '_', 'G')
  $mountpoint_graphite = regsubst($mountpoint, '/', '-', 'G')
  $graphite_target = "${::fqdn_metrics}.df${mountpoint_graphite}.df_complex-free"

  unless hiera(govuk_mount::no_op, false) {
    if $govuk_lvm != undef {
      Govuk_lvm[$govuk_lvm] -> Ext4mount[$title]
    }

    ext4mount { $title:
      disk         => $disk,
      mountoptions => $mountoptions,
      mountpoint   => $mountpoint,
    }

    govuk_tune_ext { $disk:
      require => Ext4mount[$title],
    }
  }

  @@icinga::check { "check${mountpoint_escaped}_disk_space_${::hostname}":
    check_command       => "check_nrpe!check_disk_space_arg!${percent_threshold_warning}% ${percent_threshold_critical}% ${mountpoint}",
    service_description => "low available disk space on ${mountpoint}",
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(low-available-disk-space),
    action_url          => "https://graphite.${app_domain}/render?from=-14days&until=now&width=600&height=300&target=${graphite_target}",
  }

  @@icinga::check { "check${mountpoint_escaped}_disk_inodes_${::hostname}":
    check_command       => "check_nrpe!check_disk_inodes_arg!${percent_threshold_warning}% ${percent_threshold_critical}% ${mountpoint}",
    service_description => "low available disk inodes on ${mountpoint}",
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(low-available-disk-inodes),
  }
}
