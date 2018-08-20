# == Define: govuk_harden::sysctl::conf
#
# Setup a virtual file for sysctl configuration in the /etc/sysctl.d directory
# with the approriate tag and notify params. To be realised in the
# govuk_harden::sysctl class.
#
# === Parameters
#
# [*ensure*]
#   Whether the config should be present or absent.
#
# [*source*]
#   Puppet file URI.
#
# [*content*]
#   Rendered template string.
#
# [*prefix*]
#   String to prepend the config file name with. defaults to 70. Values 60 and
#   above are considered user ones, 10 is for default os and 30 for packages.
#   This determines the ordering, so later numbers override.
define govuk_harden::sysctl::conf(
  $ensure  = 'present',
  $source  = undef,
  $content = undef,
  $prefix  = '70',
) {

  @file { "/etc/sysctl.d/${prefix}-${title}.conf":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    tag     => 'govuk_harden::sysctl::conf',
    notify  => Class['govuk_harden::sysctl'],
    owner   => 'root',
    group   => 'root',
  }
}
