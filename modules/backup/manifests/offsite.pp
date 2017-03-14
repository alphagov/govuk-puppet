# == Class: backup::offsite
#
# Transfer onsite backups to an offsite machine. Some are encrypted against
# a public GPG key, for which the private key to retrieve them can be found
# in the creds store.
#
# === Parameters
#
# [*jobs*]
#   Hash of `backup::offsite::job` resources. `ensure` parameter will be
#   added.
#
# [*archive_directory*]
#    Place to store the Duplicity cache - the default is ~/.cache/duplicity
#
class backup::offsite(
  $jobs,
  $archive_directory,
) {
  validate_hash($jobs)
  include backup::client
  include backup::repo

  create_resources('backup::offsite::job', $jobs, {
    'archive_directory' => $archive_directory,
  })
}
