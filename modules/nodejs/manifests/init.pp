# == Class: nodejs
#
# installs nodejs
#
# === Parameters:
#
# [*version*]
#   Version to install.  Leave `undef` to install any version that's available
#   Default: `undef`
#
class nodejs(
  $version = undef
) {

  if $version == undef {
    $ensure = 'present'
  } else {
    $ensure = $version
  }

  package { 'nodejs':
    ensure  => $ensure,
  }
}
