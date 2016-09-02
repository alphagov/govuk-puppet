# == Define: backup::directory
#
# Configures a directory to be backed up to the on-site backup server.
#
# === Parameters
#
# [*directory*]
#   The directory to be backed up.
#
# [*fq_dn*]
#   The fully-qualified domain name of the machine where the directory resides.
#
# [*priority*]
#   Determines the prority in which the backups should be taken.
#   Lowest numbers indicate highest priority.
#
#   Default: undef
#
define backup::directory (
    $directory,
    $fq_dn,
    $priority = undef,
) {
    $sanitised_dir  = regsubst($directory, '/', '_', 'G')
    $threshold_secs = 28 * (60 * 60)
    # Also used in template.
    $service_desc   = "backup ${fq_dn}:${directory}"

    if $priority {
      $filename = "/etc/backup/${priority}_directory_${name}"
    } else {
      $filename = "/etc/backup/directory_${name}"
    }

    file { $filename:
        content => template('backup/directory.erb'),
        mode    => '0755',
    }

    @@icinga::passive_check { "check_backup-${fq_dn}-${sanitised_dir}-${::hostname}":
      service_description => $service_desc,
      host_name           => $::fqdn,
      freshness_threshold => $threshold_secs,
      action_url          => 'https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!searchin/machine.email.carrenza/backup-1$20run-parts$20$2Fetc$2Fbackup$2Fdaily%7Csort:date',
      notes_url           => monitoring_docs_url(onsite-backups),
    }
}
