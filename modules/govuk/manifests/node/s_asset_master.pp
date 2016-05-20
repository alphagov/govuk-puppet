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
# [*s3_bucket*]
#   The URL of an S3 bucket. This can be used to either push backups or
#   sync from an environment. Format should be the full URL:
#   e.g s3://foo-bucket/
#
# [*aws_access_key_id*]
#   The AWS key ID for the bucket you are accessing.
#
# [*aws_secret_access_key*]
#   The secret part of the keypair.
#
# [*s3_env_sync_enabled*]
#   When this is enabled, it will pull down and apply backups from the
#   specified bucket, and will not push any of it's own backups.
#
class govuk::node::s_asset_master (
  $copy_attachments_hour = 4,
  $asset_slave_ip_ranges = {},
  $s3_bucket = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $s3_env_sync_enabled = false,
) inherits govuk::node::s_asset_base {

  include assets::ssh_private_key

  create_resources('ufw::allow', $asset_slave_ip_ranges)

  file { '/var/run/virus_scan':
    ensure => directory,
    owner  => 'assets',
  }

  file { '/usr/local/bin/process-uploaded-attachments.sh':
    content => template('govuk/node/s_asset_base/process-uploaded-attachments.sh.erb'),
    mode    => '0755',
  }

  file { '/usr/local/bin/copy-attachments.sh':
    content => template('govuk/node/s_asset_base/copy-attachments.sh.erb'),
    mode    => '0755',
  }

  if $s3_bucket {

    package { 's3cmd':
      ensure   => 'present',
      provider => 'pip',
    }

    file { '/home/assets/.s3cfg':
      ensure  => present,
      content => template('govuk/node/s_asset_base/s3cfg.erb'),
      owner   => 'assets',
      group   => 'assets',
    }

    file {
    [ '/etc/govuk/aws', '/etc/govuk/aws/env.d']:
      ensure  => directory,
      owner   => 'assets',
      group   => 'assets',
      mode    => '0750';
    '/etc/govuk/aws/env.d/AWS_ACCESS_KEY_ID':
      ensure  => present,
      content => $aws_access_key_id,
      owner   => 'assets',
      group   => 'assets',
      mode    => '0640';
    '/etc/govuk/aws/env.d/AWS_SECRET_ACCESS_KEY':
      ensure  => present,
      content => $aws_secret_access_key,
      owner   => 'assets',
      group   => 'assets',
      mode    => '0640';
    }

    if $s3_env_sync_enabled {
      file { '/usr/local/bin/attachments-s3-env-sync.sh':
        ensure  => present,
        mode    => '0755',
        content => template('govuk/node/s_asset_base/attachments-s3-env-sync.sh.erb'),
      }
    }

  }

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
    command => '/usr/bin/setlock -n /var/run/virus_scan/incoming.lock /usr/local/bin/process-uploaded-attachments.sh /mnt/uploads/whitehall/incoming /mnt/uploads/whitehall/clean /mnt/uploads/whitehall/infected',
    require => $cron_requires,
  }

  cron { 'process-draft-incoming-files':
    user    => 'assets',
    minute  => '*',
    command => '/usr/bin/setlock -n /var/run/virus_scan/incoming-draft.lock /usr/local/bin/process-uploaded-attachments.sh /mnt/uploads/whitehall/draft-incoming /mnt/uploads/whitehall/draft-clean /mnt/uploads/whitehall/draft-infected',
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

  @@icinga::passive_check { "full_attachments_sync_${::hostname}":
    service_description => 'Full attachments sync',
    host_name           => $::fqdn,
    freshness_threshold => 100800,
    notes_url           => monitoring_docs_url(full-attachments-sync),
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
