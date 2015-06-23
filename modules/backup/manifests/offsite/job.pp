# == Define: backup::assets::job
#
# Setup and monitor a duplicity job for offsite backups.
#
# === Parameters
#
# [*ensure*]
#   Whether to create or remove the scheduled backup.
#
# [*sources*]
#   Local path(s) to be backed up.
#
# [*destination*]
#   Remote URL to backup to.
#
# [*weekday*]
#   Day of the week on which to begin back-up
#   Default: undef, upstream default of daily
#
# [*hour*]
#   Hour at which to begin back-up
#
# [*minute*]
#   Minute at which to begin back-up
#
# [*user*]
#   User to run the backup as.
#   Default: govuk-backup
#
# [*gpg_key_id*]
#   GPG key fingerprint to encrypt backups with.
#   Default: undef, upstream default of no encryption
#
# [*archive_directory*]
#   Duplicity cache directory.
#   Default: undef, upstream default of `~/.cache`
#
define backup::offsite::job(
  $sources,
  $destination,
  $hour,
  $minute,
  $weekday = undef,
  $ensure = 'present',
  $user = 'govuk-backup',
  $gpg_key_id = undef,
  $archive_directory = undef,
){
  validate_re($ensure, '^(present|absent)$')

  # Also used by `post_command`
  $service_description = "offsite backups: ${title}"

  duplicity { $title:
    ensure                => $ensure,
    directory             => $sources,
    target                => $destination,
    weekday               => $weekday,
    hour                  => $hour,
    minute                => $minute,
    user                  => $user,
    pubkey_id             => $gpg_key_id,
    post_command          => template('backup/post_command.sh.erb'),
    archive_directory     => $archive_directory,
    remove_all_but_n_full => 2,
    full_if_older_than    => '7D',
  }

  if $ensure == 'present' {
    @@icinga::passive_check { "check_backup_offsite-${title}-${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 28 * (60 * 60), # Hours to seconds
      notes_url           => monitoring_docs_url(offsite-backups),
      action_url          => "https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!searchin/machine.email.plat1/${::hostname}\$20duplicity%7Csort:date",
    }
  }
}
