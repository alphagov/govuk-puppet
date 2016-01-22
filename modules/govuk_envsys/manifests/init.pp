# == Class: govuk_envsys
#
# Manage /etc/environment. In addition to the stock entries like PATH and
# LC_ALL.
#
class govuk_envsys {
  file { '/etc/environment':
    ensure => present,
    source => 'puppet:///modules/govuk_envsys/etc/environment',
  }
}
