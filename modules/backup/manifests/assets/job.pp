# == backup::assets::job
#
#   A class to run a Duplicity back-up job for an asset path passed in to
#   it, and then update a Nagios check
#
# == Parameters
#
#   $asset_path   Path of asset(s) to be backed-up
#   $hour         Hour at which to begin back-up
#   $minute       Minute at which to begin back-up
#   $pubkey_id    GPG key fingerprint to encrypt backups with
#   $target       Destination
#
define backup::assets::job(
  $asset_path,
  $hour,
  $minute,
  $pubkey_id,
  $target,
){

$post_command = file('backup/post_command.sh')

  duplicity { $title:
    directory    => $asset_path,
    target       => $target,
    hour         => $hour,
    minute       => $minute,
    pubkey_id    => $pubkey_id,
    post_command => $post_command
  }

  $threshold_secs = 28 * (60 * 60)        # 28 hours, in seconds

  @@icinga::passive_check { "check_backup-${title}-${::hostname}":
    service_description => $title,
    host_name           => $::fqdn,
    freshness_threshold => $threshold_secs,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#asset-backup-failed',
  }
}
