class govuk_node::asset_slave inherits govuk_node::asset_base {
  include users::assets

  cron { 'virus-check':
    ensure => 'absent'
  }

  file { "/data/master-uploads":
    ensure  => 'directory',
    owner   => 'assets',
    group   => 'assets',
    mode    => '0755',
    require => [User['assets'], Group['assets']],
  }

  mount { "/data/master-uploads":
    ensure  => "mounted",
    device  => "asset-master.${::govuk_platform}.alphagov.co.uk:/mnt/uploads",
    fstype  => "nfs",
    options => "rw",
    atboot  => true,
    require => [File["/data/master-uploads"]],
  }

  cron { 'sync-assets-from-master':
    user      => 'assets',
    minute    => '*/5',
    command   => '/usr/local/bin/sync_assets_from_master.rb /data/master-uploads /mnt/uploads whitehall/clean whitehall/incoming whitehall/infected',
  }
}
