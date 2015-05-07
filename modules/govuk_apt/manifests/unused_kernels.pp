# Class: govuk_apt::unused_kernels
#
# Periodically remove packages for Ubuntu kernels that are no longer used in
# order to reclaim disk space used.
#
class govuk_apt::unused_kernels {
  package { 'ubuntu_unused_kernels':
    ensure   => '0.2.0',
    provider => 'system_gem',
  } ->
  file { '/etc/cron.daily/remove_unused_kernels':
    ensure => present,
    source => 'puppet:///modules/govuk_apt/etc/cron.daily/remove_unused_kernels',
    mode   => '0755',
  }
}
