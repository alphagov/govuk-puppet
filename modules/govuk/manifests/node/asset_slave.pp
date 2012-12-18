class govuk::node::asset_slave inherits govuk::node::asset_base {

  include lockrun
  include users::assets

  cron { 'virus-check':
    ensure => 'absent'
  }

  file { '/data/master-uploads':
    ensure  => 'directory',
    owner   => 'assets',
    group   => 'assets',
    mode    => '0755',
  }

  $app_domain = extlookup('app_domain')

  mount { '/data/master-uploads':
    ensure  => 'mounted',
    device  => "asset-master.${app_domain}:/mnt/uploads",
    fstype  => 'nfs',
    options => 'rw',
    atboot  => true,
    require => File['/data/master-uploads'],
  }

  file { '/var/run/whitehall-assets':
    ensure => 'directory',
    owner  => 'assets',
    group  => 'assets',
  }

  cron { 'sync-assets-from-master':
    user      => 'assets',
    minute    => '*/30',
    command   => '/usr/local/bin/lockrun -L /var/run/whitehall-assets/sync.lock -q -- /usr/local/bin/sync_assets_from_master.rb /data/master-uploads /mnt/uploads whitehall/clean whitehall/incoming whitehall/infected',
  }

  cron { 'sync-assets-from-master-draft':
    user      => 'assets',
    minute    => '*/30',
    command   => '/usr/local/bin/lockrun -L /var/run/whitehall-assets/sync-draft.lock -q -- /usr/local/bin/sync_assets_from_master.rb /data/master-uploads /mnt/uploads whitehall/draft-clean whitehall/draft-incoming whitehall/draft-infected',
  }
}
