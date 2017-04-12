# == Class govuk::node::s_asset_master
#
# Node class for asset master servers.
#
# === Parameters
#
# [*copy_attachments_hour*]
#   This specifies the hour at which the full daily sync should
#   occur.
#
# [*asset_slave_ip_ranges*]
#   A hash of IP addresses that the asset slave machines run on.
#
class govuk::node::s_asset_master (
  $copy_attachments_hour = 4,
  $asset_slave_ip_ranges = {},
) inherits govuk::node::s_asset_base {

  include assets::ssh_private_key

  create_resources('ufw::allow', $asset_slave_ip_ranges)

  # daemontools provides setlock
  $cron_requires = [
    File['/usr/local/bin/copy-attachments.sh'],
    File['/usr/local/bin/process-uploaded-attachments.sh'],
    File['/usr/local/bin/virus_scan.sh'],
    File['/usr/local/bin/virus-scan-file.sh'],
    File['/var/run/virus_scan'],
    Package['daemontools'],
  ]

  cron { 'process-incoming-files':
    user    => 'assets',
    minute  => '*',
    command => '/usr/bin/setlock -n /var/run/virus_scan/incoming.lock /usr/local/bin/process-uploaded-attachments.sh /mnt/uploads/whitehall/incoming /mnt/uploads/whitehall/clean /mnt/uploads/whitehall/infected /tmp/attachments',
    require => $cron_requires,
  }

  cron { 'process-draft-incoming-files':
    user    => 'assets',
    minute  => '*',
    command => '/usr/bin/setlock -n /var/run/virus_scan/incoming-draft.lock /usr/local/bin/process-uploaded-attachments.sh /mnt/uploads/whitehall/draft-incoming /mnt/uploads/whitehall/draft-clean /mnt/uploads/whitehall/draft-infected /tmp/attachments',
    require => $cron_requires,
  }

  cron { 'copy-attachments-to-slaves':
    user    => 'assets',
    minute  => '*',
    command => '/usr/bin/setlock /var/run/virus_scan/copy-attachments-to-slaves.lock /usr/local/bin/copy-attachments-to-slaves.sh /tmp/attachments',
    require => $cron_requires,
  }

  # FIXME: There may be a couple of directories underneath /mnt/uploads that shouldn't be synced.
  # Over time we should exclude directories once we know they're not required.
  cron { 'rsync-uploads':
    user    => 'assets',
    hour    => $copy_attachments_hour,
    minute  => '18',
    command => '/usr/bin/setlock -n /var/run/virus_scan/rsync-uploads.lock /usr/local/bin/copy-attachments.sh /mnt/uploads',
    require => $cron_requires,
  }

  # FIXME: Remove once purged from production
  cron { 'rsync-clean':
    ensure => absent,
    user   => 'assets',
  }
  cron { 'rsync-clean-draft':
    ensure => absent,
    user   => 'assets',
  }

  @@icinga::passive_check { "check_process_attachments_${::hostname}":
    service_description => 'Process attachments last run',
    host_name           => $::fqdn,
    freshness_threshold => 1800,
    notes_url           => monitoring_docs_url(asset-master-attachment-processing),
  }

  @@icinga::passive_check { "copy_attachments_to_slaves_${::hostname}":
    service_description => 'Copy attachments to asset slaves',
    host_name           => $::fqdn,
    freshness_threshold => 1800,
    notes_url           => monitoring_docs_url(asset-master-attachment-processing),
  }

  @@icinga::passive_check { "full_attachments_sync_${::hostname}":
    service_description => 'Full attachments sync',
    host_name           => $::fqdn,
    freshness_threshold => 100800,
    notes_url           => monitoring_docs_url(full-attachments-sync),
  }

  @@icinga::check::graphite { "check_uploads_scan_waiting_time_${::hostname}":
    target    => 'stats.timers.govuk.app.asset-master.scan-queue.upper_90',
    warning   => 1200,
    critical  => 2400,
    desc      => 'Waiting time to pass virus scan',
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(virus-scanning),
  }

  cron { 'virus-scan-clean':
    user    => 'assets',
    hour    => '*',
    minute  => '18',
    command => '/usr/bin/setlock -n /var/run/virus_scan/clean.lock /usr/local/bin/virus_scan.sh /mnt/uploads/whitehall/clean /mnt/uploads/whitehall/infected',
    require => $cron_requires,
  }

  cron { 'virus-scan-clean-draft':
    user    => 'assets',
    hour    => '*',
    minute  => '48',
    command => '/usr/bin/setlock -n /var/run/virus_scan/clean-draft.lock /usr/local/bin/virus_scan.sh /mnt/uploads/whitehall/draft-clean /mnt/uploads/whitehall/draft-infected',
    require => $cron_requires,
  }
}
