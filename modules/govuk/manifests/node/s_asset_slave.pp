# == Class: govuk::node::s_asset_slave
#
# Sets up an asset slave machine to serve assets
#
# === Parameters
#
# [*offsite_backups*]
#   Boolean indicating whether assets should be backed up offsite
#
class govuk::node::s_asset_slave (
  $offsite_backups = false,
) inherits govuk::node::s_asset_base {

  validate_bool($offsite_backups)

  include assets::user
  include daemontools # provides setlock


  if $offsite_backups {
    include backup::assets
  }

  # Ownership and permissions come from the mount.
  file { '/data/master-uploads':
    ensure => directory,
    owner  => undef,
    group  => undef,
    mode   => undef,
  }

  $app_domain = hiera('app_domain')

  mount { '/data/master-uploads':
    ensure   => 'mounted',
    device   => "asset-master.${app_domain}:/mnt/uploads",
    fstype   => 'nfs',
    options  => 'rw,soft',
    remounts => false,
    atboot   => true,
    require  => File['/data/master-uploads'],
  }

  file { '/var/run/whitehall-assets':
    ensure => 'directory',
    owner  => 'assets',
    group  => 'assets',
  }

  $assets_sync_frequency_minutes = 30

  cron { 'sync-assets-from-master':
    user    => 'assets',
    minute  => "*/${assets_sync_frequency_minutes}",
    command => '/usr/bin/setlock -n /var/run/whitehall-assets/sync.lock /usr/local/bin/sync-assets.sh /data/master-uploads /mnt/uploads whitehall/clean whitehall/incoming whitehall/infected',
  }

  cron { 'sync-assets-from-master-draft':
    user    => 'assets',
    minute  => "*/${assets_sync_frequency_minutes}",
    command => '/usr/bin/setlock -n /var/run/whitehall-assets/sync-draft.lock /usr/local/bin/sync-assets.sh /data/master-uploads /mnt/uploads whitehall/draft-clean whitehall/draft-incoming whitehall/draft-infected',
  }

  cron { 'sync-asset-manager-from-master':
    user    => 'assets',
    minute  => '*/10',
    command => '/usr/bin/setlock -n /var/tmp/asset-manager.lock /usr/bin/rsync -a --delete /data/master-uploads/asset-manager/ /mnt/uploads/asset-manager',
  }

  @@icinga::passive_check { "sync_assets_from_master_on_${::hostname}":
    service_description => 'Local assets sync from master to slave',
    host_name           => $::fqdn,
    freshness_threshold => ($assets_sync_frequency_minutes * 2) * 60,
  }
}
