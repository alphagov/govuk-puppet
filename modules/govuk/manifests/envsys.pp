# == Class: govuk::envsys
#
# Manage /etc/environment. In addition to the stock entries like PATH and
# LC_ALL this currently contains some FACTER_govuk_* variables that are in
# use across our estate.
#
# These are treated as "sticky". In the respect that whatever Puppet
# receives from Facter (and thus the current environment) will be written
# out to the file. In most cases this won't change. Though it does mean that
# they can be updated by running:
#
#     FACTER_govuk_provider=foo puppet agent -t
#
# These shouldn't always live here. When govuk_platform, govuk_setenv and
# Plek have stabilised we should consider making /etc/environment a static
# file outside of this module and moving any remaining vars to an
# /etc/bashrc.d type structure (not profile.d because no everything uses
# login shells - like cron).
#
class govuk::envsys {
  # FACTER_govuk_* vars that currently exist.
  $govuk_vars = [
    'govuk_class',
    'govuk_platform',
    'govuk_provider',
  ]

  file { '/etc/environment':
    ensure  => present,
    content => template('govuk/etc/environment.erb'),
  }
}
