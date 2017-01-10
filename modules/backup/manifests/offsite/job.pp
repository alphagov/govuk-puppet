# == Define: backup::offsite::job
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
# [*bucket*]
#   Name of the s3 bucket to push backups to
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
# [*pre_command*]
#   Duplicity command to run before backup
#
# [*aws_access_key_id*]
#   AWS access key
#
# [*aws_secret_access_key*]
#   AWS secret access key
#
define backup::offsite::job(
  $sources,
  $hour,
  $minute,
  $destination = undef,
  $bucket = undef,
  $weekday = undef,
  $ensure = 'present',
  $user = 'govuk-backup',
  $gpg_key_id = undef,
  $archive_directory = undef,
  $pre_command = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
){
  validate_re($ensure, '^(present|absent)$')

  # Also used by `post_command`
  $service_description = "offsite backups: ${title}"

  duplicity { $title:
    ensure                => $ensure,
    directory             => $sources,
    bucket                => $bucket,
    dest_id               => $aws_access_key_id,
    dest_key              => $aws_secret_access_key,
    target                => $destination,
    weekday               => $weekday,
    hour                  => $hour,
    minute                => $minute,
    user                  => $user,
    pubkey_id             => $gpg_key_id,
    pre_command           => $pre_command,
    post_command          => template('backup/post_command.sh.erb'),
    archive_directory     => $archive_directory,
    remove_all_but_n_full => 2,
    full_if_older_than    => '7D',
  }

  if $weekday == undef { # duplicity job runs daily
    $freshness_threshold = 28 * 60 * 60 # one day plus 4 hours
  } else { # duplicity runs weekly
    $freshness_threshold = (4 + (7 * 24)) * 60 * 60 # one week plus 4 hours
  }

  if $ensure == 'present' {
    @@icinga::passive_check { "check_backup_offsite-${title}-${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => $freshness_threshold,
      notes_url           => monitoring_docs_url(offsite-backups),
      action_url          => "https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!searchin/machine.email.carrenza/${::hostname}\$20duplicity%7Csort:date",
    }
  }
}
