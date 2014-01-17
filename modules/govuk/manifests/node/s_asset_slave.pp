class govuk::node::s_asset_slave inherits govuk::node::s_asset_base {
  include assets::user
  include daemontools # provides setlock

  $offsite_backup = extlookup('offsite-backups', 'off')

  case $offsite_backup {
    'on':    { include backup::assets }
    default: {}
  }

  # Ownership and permissions come from the mount.
  file { '/data/master-uploads':
    ensure  => directory,
    owner   => undef,
    group   => undef,
    mode    => undef,
  }

  $app_domain = extlookup('app_domain')

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

  cron { 'sync-assets-from-master':
    user      => 'assets',
    minute    => '*/30',
    command   => '/usr/bin/setlock -n /var/run/whitehall-assets/sync.lock /usr/local/bin/sync-assets.sh /data/master-uploads /mnt/uploads whitehall/clean whitehall/incoming whitehall/infected',
  }

  cron { 'sync-assets-from-master-draft':
    user      => 'assets',
    minute    => '*/30',
    command   => '/usr/bin/setlock -n /var/run/whitehall-assets/sync-draft.lock /usr/local/bin/sync-assets.sh /data/master-uploads /mnt/uploads whitehall/draft-clean whitehall/draft-incoming whitehall/draft-infected',
  }
}
