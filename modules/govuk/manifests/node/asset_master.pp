class govuk_node::asset_master inherits govuk_node::asset_base {

  cron { 'virus-check':
    ensure    => 'absent',
  }

  cron { 'virus-scan-incoming':
    user      => 'assets',
    minute    => '*/2',
    command   => '/usr/local/bin/virus_scan.sh /mnt/uploads/whitehall/incoming /mnt/uploads/whitehall/infected /mnt/uploads/whitehall/clean',
    require   => File['/usr/local/bin/virus_scan.sh'],
  }

  cron { 'virus-scan-clean':
    user      => 'assets',
    hour      => '4',
    minute    => '18',
    command   => '/usr/local/bin/virus_scan.sh /mnt/uploads/whitehall/clean /mnt/uploads/whitehall/infected',
    require   => File['/usr/local/bin/virus_scan.sh'],
  }

  cron { 'virus-scan-incoming-draft':
    user      => 'assets',
    minute    => '*/2',
    command   => '/usr/local/bin/virus_scan.sh /mnt/uploads/whitehall/draft-incoming /mnt/uploads/whitehall/draft-infected /mnt/uploads/whitehall/draft-clean',
    require   => File['/usr/local/bin/virus_scan.sh'],
  }

  cron { 'virus-scan-clean-draft':
    user      => 'assets',
    hour      => '4',
    minute    => '48',
    command   => '/usr/local/bin/virus_scan.sh /mnt/uploads/whitehall/draft-clean /mnt/uploads/whitehall/draft-infected',
    require   => File['/usr/local/bin/virus_scan.sh'],
  }
}
