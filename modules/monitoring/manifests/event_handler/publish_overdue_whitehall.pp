# == Class: monitoring::event_handler::publish_overdue_whitehall
#
# Configure an Icinga event handler that publishes Whitehall overdue documents.
#
class monitoring::event_handler::publish_overdue_whitehall () {

  icinga::check_config { 'publish_overdue_whitehall':
    source  => 'puppet:///modules/monitoring/publish_overdue_whitehall.cfg',
    require => File['/usr/local/bin/event_handlers/publish_overdue_whitehall.sh'],
  }

  file { '/usr/local/bin/event_handlers/publish_overdue_whitehall.sh':
    source => 'puppet:///modules/monitoring/usr/local/bin/event_handlers/publish_overdue_whitehall.sh',
    mode   => '0755',
  }

}
