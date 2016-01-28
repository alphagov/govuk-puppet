# == Class: last_puppet_run
#
# Checks to see if puppet has been run recently for use on a dev VM.
#
class last_puppet_run {
  file { '/etc/profile.d/last_puppet_run.sh':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/last_puppet_run/etc/profile.d/last_puppet_run.sh',
  }
}
