# == Define: govuk_lvm
#
# Module to wrap lvm::volume so we dont try to do it on vagrant machines.
# the title of the resource will be the logical volume name.
#
# === Parameters
#
# [*pv*]
#   the physical volume the vg will use
#
# [*vg*]
#   the name of the volume group the logical volume will be created in.
#
# === Example
#
# To create a logical volume called test on volume group example using /dev/sdb1 as the physical volume.
# This would be available as /dev/mapper/example-test for mounting by govuk_mount
#
#   govuk_lvm { 'test':
#     pv => '/dev/sdb1',
#     vg => 'example',
#   }
#
define govuk_lvm(
  # lvm::volume[] options (@dcarley longs for **kwargs)
  $pv,
  $vg,
  $ensure = present,
  $fstype = 'ext4',
  ) {
  unless hiera(govuk_lvm::no_op, false) {

    $filesystem = "/dev/${vg}/${title}"

    physical_volume { $pv:
      ensure    => $ensure,
      unless_vg => $vg,
    }

    volume_group { $vg:
      ensure           => $ensure,
      physical_volumes => $pv,
      require          => Physical_volume[$pv],
      createonly       => true,
    }

    logical_volume { $title:
      ensure       => $ensure,
      volume_group => $vg,
      require      => Volume_group[$vg],
    }

    filesystem { $filesystem:
      ensure  => $ensure,
      fs_type => $fstype,
      require => Logical_volume[$title],
    }
  }
}
