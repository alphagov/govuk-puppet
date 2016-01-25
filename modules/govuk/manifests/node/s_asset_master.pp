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

  file { '/var/run/virus_scan':
    ensure => directory,
    owner  => 'assets',
  }

  # daemontools provides setlock
  $cron_requires = [
    File[
      '/usr/local/bin/copy-attachments.sh',
      '/usr/local/bin/process-uploaded-attachments.sh',
      '/usr/local/bin/virus_scan.sh',
      '/usr/local/bin/virus-scan-file.sh',
      '/var/run/virus_scan'
    ],
    Package['daemontools'],
  ]

  cron { 'process-incoming-files':
    user    => 'assets',
    minute  => '*',
    command => '/usr/bin/setlock -n /var/run/virus_scan/incoming.lock /usr/local/bin/process-uploaded-attachments.sh /mnt/uploads/whitehall/incoming /mnt/uploads/whitehall/clean /mnt/uploads/whitehall/infected',
    require => $cron_requires,
  }

  cron { 'process-draft-incoming-files':
    user    => 'assets',
    minute  => '*',
    command => '/usr/bin/setlock -n /var/run/virus_scan/incoming-draft.lock /usr/local/bin/process-uploaded-attachments.sh /mnt/uploads/whitehall/draft-incoming /mnt/uploads/whitehall/draft-clean /mnt/uploads/whitehall/draft-infected',
    require => $cron_requires,
  }

  cron { 'rsync-clean':
    user    => 'assets',
    hour    => $copy_attachments_hour,
    minute  => '18',
    command => '/usr/bin/setlock -n /var/run/virus_scan/rsync-clean.lock /usr/local/bin/copy-attachments.sh /mnt/uploads/whitehall/clean',
    require => $cron_requires,
  }

  cron { 'rsync-clean-draft':
    user    => 'assets',
    hour    => $copy_attachments_hour,
    minute  => '18',
    command => '/usr/bin/setlock -n /var/run/virus_scan/rsync-clean.lock /usr/local/bin/copy-attachments.sh /mnt/uploads/whitehall/draft-clean',
    require => $cron_requires,
  }

  @@icinga::passive_check { "check_process_attachments_${::hostname}":
    service_description => 'Process attachments last run',
    host_name           => $::fqdn,
    freshness_threshold => 1800,
    notes_url           => monitoring_docs_url(asset-master-attachment-processing),
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
