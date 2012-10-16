class govuk_node::asset_master inherits govuk_node::asset_base {

  cron { 'virus-check':
    user      => 'assets',
    minute    => '*/2',
    command   => '/usr/local/bin/virus_check.sh /mnt/uploads/whitehall/incoming /mnt/uploads/whitehall/clean /mnt/uploads/whitehall/infected',
    require   => File['/usr/local/bin/virus_check.sh'],
  }

}
