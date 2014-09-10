# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
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
    target       => "${target}",
    hour         => $hour,
    minute       => $minute,
    pubkey_id    => "${pubkey_id}",
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
