# == Class: govuk::envsys
#
# Manage /etc/environment. In addition to the stock entries like PATH and
# LC_ALL.
#
class govuk::envsys {
  file { '/etc/environment':
    ensure  => present,
    source  => 'puppet:///modules/govuk/etc/environment',
  }
}
