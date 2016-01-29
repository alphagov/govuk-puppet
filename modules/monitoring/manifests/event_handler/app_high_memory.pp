# == Class: monitoring::event_handler::app_high_memory
#
# Configure an Icinga event handler that restarts a GOV.UK application if it has
# triggered a high memory alert
#
class monitoring::event_handler::app_high_memory () {

  icinga::check_config { 'govuk_app_high_memory':
    source  => 'puppet:///modules/monitoring/govuk_app_high_memory.cfg',
    require => File['/usr/local/bin/event_handlers/govuk_app_high_memory.sh'],
  }

  file { '/usr/local/bin/event_handlers/govuk_app_high_memory.sh':
    source => 'puppet:///modules/monitoring/usr/local/bin/event_handlers/govuk_app_high_memory.sh',
    mode   => '0755',
  }

}
