# == Class: backup::offsite
#
# Transfer onsite backups to an offsite machine. Some are encrypted against
# a public GPG key, for which the private key to retrieve them can be found
# in the creds store.
#
# === Parameters
#
# [*enable*]
#   Whether to enable the generation and sending of encrypted backups
#   Default: False
#
# [*jobs*]
#   Hash of `backup::offsite::job` resources. `ensure` parameter will be
#   added.
#
# [*dest_host*]
#    Hostname or IP of the machine to send the backups to.
#
# [*dest_host_key*]
#    The SSH key to use to authenticate to the destination machine.
#
# [*archive_directory*]
#    Place to store the Duplicity cache - the default is ~/.cache/duplicity
#
class backup::offsite(
  $jobs,
  $dest_host,
  $dest_host_key,
  $archive_directory,
) {
  validate_hash($jobs)
  include backup::client
  include backup::repo

  sshkey { $dest_host:
    ensure => present,
    type   => 'ssh-rsa',
    key    => $dest_host_key,
  }

  create_resources('backup::offsite::job', $jobs, {
    'archive_directory' => $archive_directory,
  })
}
