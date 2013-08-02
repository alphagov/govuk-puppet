class govuk::node::s_asset_master inherits govuk::node::s_asset_base {

  # Provides setlock
  include daemontools

  # Java needed for tika
  include java::oracle7::jdk
  include java::oracle7::jre

  class { 'java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  package { 'libxtst6':
    ensure => 'latest'
  }

  # Used to extract text from file attachments when indexing
  package { 'tika':
    ensure  => '1.4-gds1',
    require => [
      Class['java::set_defaults'],
      Package['libxtst6']
    ]
  }

  cron { 'virus-check':
    ensure    => 'absent',
  }

  file { '/var/run/virus_scan':
    ensure  => directory,
    owner   => 'assets',
  }

  $cron_requires = [
    File[
      '/usr/local/bin/virus_scan.sh',
      '/usr/local/bin/extract_text_from_files.rb',
      '/var/run/virus_scan'
    ],
    Class['daemontools'],
  ]

  cron { 'virus-scan-incoming':
    user      => 'assets',
    minute    => '*/2',
    command   => '/usr/bin/setlock -n /var/run/virus_scan/incoming.lock /usr/local/bin/virus_scan.sh /mnt/uploads/whitehall/incoming /mnt/uploads/whitehall/infected /mnt/uploads/whitehall/clean',
    require   => $cron_requires,
  }

  cron { 'virus-scan-clean':
    user      => 'assets',
    hour      => '4',
    minute    => '18',
    command   => '/usr/bin/setlock -n /var/run/virus_scan/clean.lock /usr/local/bin/virus_scan.sh /mnt/uploads/whitehall/clean /mnt/uploads/whitehall/infected',
    require   => $cron_requires,
  }

  cron { 'virus-scan-incoming-draft':
    user      => 'assets',
    minute    => '*/2',
    command   => '/usr/bin/setlock -n /var/run/virus_scan/incoming-draft.lock /usr/local/bin/virus_scan.sh /mnt/uploads/whitehall/draft-incoming /mnt/uploads/whitehall/draft-infected /mnt/uploads/whitehall/draft-clean',
    require   => $cron_requires,
  }

  cron { 'virus-scan-clean-draft':
    user      => 'assets',
    hour      => '4',
    minute    => '48',
    command   => '/usr/bin/setlock -n /var/run/virus_scan/clean-draft.lock /usr/local/bin/virus_scan.sh /mnt/uploads/whitehall/draft-clean /mnt/uploads/whitehall/draft-infected',
    require   => $cron_requires,
  }
}
