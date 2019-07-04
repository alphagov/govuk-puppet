# == Class govuk::node::s_asset_base
#
# Base node class for asset servers.
#
# === Parameters
#
# [*firewall_allow_ip_range*]
#   The IP range that is allowed to access asset machines
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
# [*process_uploaded_attachments_to_s3*]
#   A boolean that when true means that when files are initially processed after
#   being uploaded they copied to an S3 bucket as well as the asset slaves.
#
# [*push_attachments_to_s3*]
#   A boolean that when true schedules a full rsync-like push of all files to an
#   S3 bucket.
#
# [*s3_env_sync_enabled*]
#   When this is enabled, it will pull down and apply backups from the
#   specified bucket, and will not push any of it's own backups.
#
class govuk::node::s_asset_base (
  $firewall_allow_ip_range,
  $s3_bucket = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $process_uploaded_attachments_to_s3 = false,
  $push_attachments_to_s3 = false,
  $s3_env_sync_enabled = false,
  $alert_hostname = 'alert.cluster',
) inherits govuk::node::s_base{
  validate_string($firewall_allow_ip_range)

  unless $::aws_migration {
    include assets::user
  }

  if $::aws_migration {
    $app_domain_internal = hiera('app_domain_internal')
    $mount_point = "assets.${app_domain_internal}:/"

    package { 'nfs-common':
      ensure => 'present',
    }

    mount { '/mnt/uploads':
      ensure   => 'mounted',
      device   => $mount_point,
      fstype   => 'nfs',
      options  => 'rw,soft',
      remounts => false,
      atboot   => true,
      require  => [File['/mnt/uploads'], Package['nfs-common']],
    }
  }

  $directories = [
    '/mnt/uploads/whitehall',
    '/mnt/uploads/whitehall/asset-manager-tmp',
    '/mnt/uploads/whitehall/attachment-cache',
    '/mnt/uploads/whitehall/bulk-upload-zip-file-tmp',
    '/mnt/uploads/whitehall/carrierwave-tmp',
    '/mnt/uploads/whitehall/clean',
    '/mnt/uploads/whitehall/draft-clean',
    '/mnt/uploads/whitehall/draft-incoming',
    '/mnt/uploads/whitehall/draft-infected',
    '/mnt/uploads/whitehall/fatality_notices',
    '/mnt/uploads/whitehall/incoming',
    '/mnt/uploads/whitehall/infected',
  ]

  if $::aws_migration {
    # Ensure that /mnt/uploads dir is created before mounting to EFS, and
    # the rest of the directories are created after mounting to the EFS share
    file { '/mnt/uploads':
      ensure  => directory,
      owner   => 'deploy',
      group   => 'deploy',
      mode    => '0775',
      purge   => false,
      require => [
        Group['deploy'],
        User['deploy'],
      ],
    }

    file { $directories:
      ensure  => directory,
      owner   => 'deploy',
      group   => 'deploy',
      mode    => '0775',
      purge   => false,
      require => [
        Group['deploy'],
        User['deploy'],
        Mount['/mnt/uploads'],
      ],
    }

    file { '/var/run/virus_scan':
      ensure => directory,
      owner  => 'deploy',
    }
  } else {
    file { '/mnt/uploads':
      ensure  => directory,
      owner   => 'assets',
      group   => 'assets',
      mode    => '0775',
      purge   => false,
      require => [
        Group['assets'],
        User['assets'],
        Govuk_mount['/mnt/uploads']
      ],
    }

    file { $directories:
      ensure  => directory,
      owner   => 'assets',
      group   => 'assets',
      mode    => '0775',
      purge   => false,
      require => [
        Group['assets'],
        User['assets'],
        Govuk_mount['/mnt/uploads']
      ],
    }

    file { '/var/run/virus_scan':
      ensure => directory,
      owner  => 'assets',
    }

    file { '/etc/exports':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => '/mnt/uploads     10.0.0.0/8(rw,fsid=0,insecure,no_subtree_check,async,all_squash,anonuid=2900,anongid=2900)',
      require => File['/mnt/uploads'],
      notify  => Service['nfs-kernel-server'],
    }

    ufw::allow { 'Allow all access from backend machines':
      from => $firewall_allow_ip_range,
    }

    package { 'nfs-kernel-server':
      ensure => installed,
    }

    service { 'nfs-kernel-server':
      ensure    => running,
      hasstatus => true,
      require   => Package['nfs-kernel-server'],
    }

    collectd::plugin { 'nfs':
      require   => Package['nfs-kernel-server'],
    }
  }

  cron { 'tmpreaper-bulk-upload-zip-file-tmp':
    command => '/usr/sbin/tmpreaper -am 24h /mnt/uploads/whitehall/bulk-upload-zip-file-tmp/',
    user    => 'root',
    hour    => 5,
    minute  => 5,
  }
  cron { 'tmpreaper-carrierwave-tmp':
    command => '/usr/sbin/tmpreaper -T300 --mtime 7d /mnt/uploads/whitehall/carrierwave-tmp/',
    user    => 'root',
    hour    => 5,
    minute  => 15,
  }
  cron { 'tmpreaper-attachment-cache':
    command => '/usr/sbin/tmpreaper -T300 --mtime 14d /mnt/uploads/whitehall/attachment-cache/',
    user    => 'root',
    hour    => 5,
    minute  => 25,
  }

  file { '/usr/local/bin/process-uploaded-attachments.sh':
    content => template('govuk/node/s_asset_base/process-uploaded-attachments.sh.erb'),
    mode    => '0755',
  }

  file { '/usr/local/bin/copy-attachments-to-slaves.sh':
    content => template('govuk/node/s_asset_base/copy-attachments-to-slaves.sh.erb'),
    mode    => '0755',
  }

  file { '/usr/local/bin/copy-attachments.sh':
    content => template('govuk/node/s_asset_base/copy-attachments.sh.erb'),
    mode    => '0755',
  }

  if $s3_bucket {

    package { 's3cmd':
      ensure   => '2.0',
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
      ensure => directory,
      owner  => 'assets',
      group  => 'assets',
      mode   => '0750';
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

    if $push_attachments_to_s3 {
      file { '/usr/local/bin/push_attachments_to_s3.sh':
        ensure  => present,
        content => template('govuk/node/s_asset_base/push-attachments-to-s3.sh.erb'),
        mode    => '0755',
      }

      cron { 'push_attachments_to_s3':
        command => '/usr/bin/setlock -n /var/run/virus_scan/push-attachments.lock /usr/local/bin/push_attachments_to_s3.sh /mnt/uploads',
        user    => 'assets',
        hour    => 21,
        minute  => 0,
      }

      @@icinga::passive_check { "push_attachments_to_s3_${::hostname}":
        service_description => 'Push attachments to S3',
        host_name           => $::fqdn,
        freshness_threshold => 100800,
      }
    }
  }
}
