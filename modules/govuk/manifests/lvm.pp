# == Define: govuk::lvm
#
# Module to wrap lvm::volume so we dont try to do it on vagrant machines.
# the title of the resource will be the logical volume name.
#
# === Parameters
#
# [*pv*]
#   the physical volume the vg will use
# [*vg*]
#   the name of the volume group the logical volume will be created in.
#
# === Example
#
# To create a logical volume called test on volume group example using /dev/sdb1 as the physical volume.
# This would be available as /dev/mapper/example-test for mounting by govuk::mount
#
#   govuk::lvm { 'test':
#     pv => '/dev/sdb1',
#     vg => 'example',
#   }
#
define govuk::lvm(
  # lvm::volume[] options (@dcarley longs for **kwargs)
  $pv,
  $vg,
  $ensure = present,
  $fstype = 'ext4'
) {
  $exclude_environments = ['vagrant']

  unless $::environment in $exclude_environments {
    lvm::volume { $title:
      ensure       => $ensure,
      pv           => $pv,
      vg           => $vg,
      fstype       => $fstype,
    }
  }

}
