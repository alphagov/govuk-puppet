# == Class: govuk_apt::local_mirror_alias
#
# Installs a host entry that points to the local apt mirror
#
# === Parameters
#
# [*address*]
#   The IP address of the apt mirror. Will be aliased to `hostname`
#
class govuk_apt::local_mirror_alias (
  $address  = undef,
) {

  host { 'apt_mirror.cluster':
    ip      => $address,
    comment => 'Alias to the production apt mirror',
  }

}
