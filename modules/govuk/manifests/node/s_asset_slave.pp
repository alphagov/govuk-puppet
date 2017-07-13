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

  include assets::ssh_authorized_key

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

  # FIXME: Remove the NFS mount once asset-manager is no longer using it.
  mount { '/data/master-uploads':
    ensure   => 'mounted',
    device   => "asset-master.${app_domain}:/mnt/uploads",
    fstype   => 'nfs',
    options  => 'rw,soft',
    remounts => false,
    atboot   => true,
    require  => File['/data/master-uploads'],
  }

  cron { 'sync-asset-manager-from-master':
    user    => 'assets',
    minute  => '*/10',
    command => '/usr/bin/setlock -n /var/tmp/asset-manager.lock /usr/bin/rsync -a --delete /data/master-uploads/asset-manager/ /mnt/uploads/asset-manager',
  }

  $master_metrics_hostname = regsubst($::fqdn_metrics, 'slave-\d', 'master-1')
  $graphite_mnt_uploads_metric = 'df-mnt-uploads.df_complex-used'
  $master_metric = "${master_metrics_hostname}.${graphite_mnt_uploads_metric}"
  $slave_metric = "${::fqdn_metrics}.${graphite_mnt_uploads_metric}"

  @@icinga::check::graphite { "asset_master_and_slave_disk_space_similar_from_${::hostname}":
    target    => "movingMedian(absolute(transformNull(diffSeries(${slave_metric},${master_metric}),0)),10)",
    critical  => to_bytes('512 MB'),
    warning   => to_bytes('384 MB'),
    desc      => 'Asset master and slave are using about the same amount of disk space',
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(asset-master-slave-disk-space-comparison),
  }
}
