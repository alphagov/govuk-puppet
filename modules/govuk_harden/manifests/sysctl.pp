# == Class: govuk_harden::sysctl
#
# Applies some basic OS hardening via the sysctl configuration
#
class govuk_harden::sysctl {

  # TODO: remove this once ran on all environments or after 2018-09-01
  file { '/etc/sysctl.conf':
    ensure => absent,
  }
  # Adjusting kernel networking parameters
  file { '/etc/sysctl.d/60-govuk-base.conf':
    ensure => present,
    source => 'puppet:///modules/govuk_harden/sysctl.d/60-govuk-base.conf',
    notify => Exec['update sysctl'],
    owner  => 'root',
    group  => 'root',
  }

  # Realise the virtual resources for this configuration. This allows there
  # not to be a hard dependency between configuration files and this class
  File <| tag == 'govuk_harden::sysctl::conf' |>

  exec { 'update sysctl':
    command     => '/sbin/sysctl --system',
    refreshonly => true,
  }
}
