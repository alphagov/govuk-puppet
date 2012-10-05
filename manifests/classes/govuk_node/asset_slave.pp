class govuk_node::asset_slave inherits govuk_node::asset_master {

  file { "/data/master-uploads":
    ensure  => 'directory',
    owner   => 'assets',
    group   => 'assets',
    mode    => '0664',
    require => [User['assets'], Group['assets']],
  }

  mount { "/data/master-uploads":
    ensure  => "mounted",
    device  => "asset-master.${::govuk_platform}.alphagov.co.uk:/mnt/uploads",
    fstype  => "nfs",
    options => "ro",
    atboot  => true,
    require => [File["/data/master-uploads"]],
  }

  cron { 'sync-assets-from-master':
    user      => 'assets',
    minute    => '*/5',
    command   => '/usr/bin/rsync -r /data/master-uploads/ /mnt/uploads',
  }
}
