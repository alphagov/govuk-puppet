# == Class: govuk_harden::sysctl
#
# Applies some basic OS hardening via the sysctl configuration
#
class govuk_harden::sysctl {

  # Adjusting kernel networking parameters
  file { '/etc/sysctl.conf':
    ensure => present,
    source => 'puppet:///modules/govuk_harden/sysctl/sysctl.conf',
    notify => Exec['read sysctl.conf'],
    owner  => 'root',
    group  => 'root',
  }

  exec { 'read sysctl.conf':
    command     => '/sbin/sysctl -p',
    refreshonly => true,
  }


}
