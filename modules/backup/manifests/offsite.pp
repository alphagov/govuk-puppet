# == Class: backup::offsite
#
# This class arranges for backups on disk in /data/backups to be encrypted
# with a supplied public key (the private key is not needed) and sent via
# scp to a destination host. Backups can be retrieved from this destination
# host and decrypted with the private key (which is not stored on the
# destination machine either)
#
# === Parameters
#
# [*dest_folder*]
#    The folder on the destination machine to send the backups to.
#
# [*dest_host*]
#    Hostname or IP of the machine to send the backups to.
#
# [*dest_host_key*]
#    The SSH key to use to authenticate to the destination machine.
#
# [*enable*]
#    Whether to enable the generation and sending of encrypted backups
#    Default: False
#
class backup::offsite(
  $dest_folder = '',
  $dest_host,
  $dest_host_key,
  $enable = false,
) {

  include backup::client

  sshkey { $dest_host:
    ensure => present,
    type   => 'ssh-rsa',
    key    => $dest_host_key,
  }

  $threshold_secs = 28 * (60 * 60)
  # Also used in template.
  $service_desc   = 'offsite backup'

  file { '/usr/local/bin/offsite-backup':
    ensure  => present,
    content => template('backup/usr/local/bin/offsite-backup.erb'),
    mode    => '0755',
    require => Sshkey[$dest_host],
  }

  cron { 'offsite-backup':
    command => '/usr/local/bin/offsite-backup',
    user    => 'govuk-backup',
    hour    => 8,
    minute  => 13,
    require => File['/usr/local/bin/offsite-backup'],
  }

  @@icinga::passive_check { "check_backup_offsite-${::hostname}":
    service_description => $service_desc,
    host_name           => $::fqdn,
    freshness_threshold => $threshold_secs,
  }
}
