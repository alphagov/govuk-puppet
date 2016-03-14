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
  if !defined(Govuk_host[$::hostname]) {
    fail("Unable to find Govuk_host[${::hostname}]. Aborting so as not to break hostname(1)")
  }

  resources { 'host':
    purge => true,
  }
}
