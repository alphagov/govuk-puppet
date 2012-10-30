class govuk_node::asset_slave inherits govuk_node::asset_base {
  include users::assets

  cron { 'virus-check':
    ensure => 'absent'
  }

  file { "/data/master-uploads":
    ensure  => 'directory',
    owner   => 'assets',
    group   => 'assets',
    mode    => '0775',
    require => [User['assets'], Group['assets']],
  }

  $app_domain = extlookup('app_domain')

  mount { "/data/master-uploads":
    ensure  => "mounted",
    device  => "asset-master.${app_domain}:/mnt/uploads",
    fstype  => "nfs",
    options => "ro",
    atboot  => true,
    require => [File["/data/master-uploads"]],
  }

  cron { 'sync-assets-from-master':
    user      => 'assets',
    minute    => '*/5',
    command   => '/usr/local/bin/sync_assets_from_master.rb /data/master-uploads /mnt/uploads whitehall/clean whitehall/incoming whitehall/infected',
  }
}
