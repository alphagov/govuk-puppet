class nagios::config::pingdom {
  file { '/usr/local/bin/check_pingdom.sh':
    source => 'puppet:///modules/nagios/usr/local/bin/check_pingdom.sh',
    mode   => '0755',
  }

  nagios::check_config::pingdom {
    'homepage':
      check_id => 489558;
    'calendar':
      check_id => 489561;
    'quick_answer':
      check_id => 662431;
    'search':
      check_id => 662465;
    'smart_answer':
      check_id => 489560;
    'specialist':
      check_id => 662460;
  }
}
