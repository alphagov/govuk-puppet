# == Class: hosts::purge
#
# Purge unmanaged /etc/hosts entries.
#
# This will abort the catalog if a govuk_host resource doesn't exist for
# the machine's `$::hostname` so as to prevent it breaking local `hostname`
# resolution.
#
# NB: This is only designed to catch boxes we have forgotten about adding to
# `hosts::production`. It doesn't care if we've marked the resource as
# `ensure => absent`.
#
class hosts::purge {

  # Specifically for hosts that exist as a node class but do not use the Govuk_host defined type
  # eg hosts that are only present in AWS
  $whitelist = [
    'db-admin-1',
  ]

  if ! ($::hostname in $whitelist) {
    if !defined(Govuk_host[$::hostname]) {
      fail("Unable to find Govuk_host[${::hostname}]. Aborting so as not to break hostname(1)")
    }
  }

  resources { 'host':
    purge => true,
  }
}
