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
# [*s3_use_multiprocessing*]
#   Make use of duplicity option to run multiple processes when uploading to
#   S3
#
# [*s3_multipart_chunk_size*]
#   The size of a multipart chunk, the default is 25MB. For larger datasets this
#   should be higher. The smaller the chunk, the more files are split up.
#
# [*s3_multipart_max_procs*]
#   The maximum number of processes the multiprocessing can start.
#
# [*alert_hostname*]
#   The hostname of the alert service, to send ncsa notifications.
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
  $s3_use_multiprocessing = undef,
  $s3_multipart_chunk_size = undef,
  $s3_multipart_max_procs = undef,
  $alert_hostname = 'alert.cluster',
){
  validate_re($ensure, '^(present|absent)$')

  # Also used by `post_command`
  $service_description = "offsite backups: ${title}"

  duplicity { $title:
    ensure                  => $ensure,
    directory               => $sources,
    bucket                  => $bucket,
    dest_id                 => $aws_access_key_id,
    dest_key                => $aws_secret_access_key,
    target                  => $destination,
    weekday                 => $weekday,
    hour                    => $hour,
    minute                  => $minute,
    user                    => $user,
    pubkey_id               => $gpg_key_id,
    pre_command             => $pre_command,
    post_command            => template('backup/post_command.sh.erb'),
    archive_directory       => $archive_directory,
    remove_all_but_n_full   => 2,
    full_if_older_than      => '7D',
    s3_use_multiprocessing  => $s3_use_multiprocessing,
    s3_multipart_chunk_size => $s3_multipart_chunk_size,
    s3_multipart_max_procs  => $s3_multipart_max_procs,
  }

  if $weekday == undef { # duplicity job runs daily
    $freshness_threshold = 32 * 60 * 60 # one day plus 8 hours
  } else { # duplicity runs weekly
    $freshness_threshold = (8 + (7 * 24)) * 60 * 60 # one week plus 8 hours
  }

  @@icinga::passive_check { "check_backup_offsite-${title}-${::hostname}":
    ensure              => $ensure,
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => $freshness_threshold,
    notes_url           => monitoring_docs_url(offsite-backups),
    action_url          => "https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!searchin/machine.email.carrenza/${::hostname}\$20duplicity%7Csort:date",
  }
}
