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
#   $ssh_id       SSH key filepath to use to connect to remote host
#   $target       Destination
#
define backup::assets::job(
  $asset_path,
  $hour,
  $minute,
  $pubkey_id,
  $ssh_id,
  $target,
){

$service_description = "Off-site asset backups: ${title}"
$post_command = template('backup/post_command.sh.erb')

  duplicity { $title:
    directory    => $asset_path,
    target       => $target,
    hour         => $hour,
    minute       => $minute,
    pubkey_id    => $pubkey_id,
    ssh_id       => $ssh_id,
    post_command => $post_command
  }

  $threshold_secs = 28 * (60 * 60)        # 28 hours, in seconds

  @@icinga::passive_check { "check_backup-${title}-${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => $threshold_secs,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#asset-backup-failed',
  }
}
