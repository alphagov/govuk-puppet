# == Define: govuk_tune_ext
#
# Tune an ext filesystem
#
# == Parameters
#
# [*disk*]
# the ext disk to be tuned
#
define govuk_tune_ext (
  $disk = $title
) {

  exec { "no-reserved-blocks-${disk}":
    command => "/sbin/tune2fs -m 0 ${disk}",
    onlyif  => "/usr/bin/test $(/sbin/tune2fs -l ${disk} | /usr/bin/awk '/Reserved block count/ { print \$4}') -gt 0",
  }

}
