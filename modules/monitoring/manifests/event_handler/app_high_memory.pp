# == Class: monitoring::event_handler::app_high_memory
#
# Configure an Icinga event handler that restarts a GOV.UK application if it has
# triggered a high memory alert
#
class monitoring::event_handler::app_high_memory () {

  icinga::check_config { 'govuk_app_high_memory':
    source  => 'puppet:///modules/govuk/govuk_app_high_memory.cfg',
    require => File['/usr/local/bin/event_handlers/govuk_app_high_memory.sh'],
  }

  @icinga::plugin { 'reload_service':
    source => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/reload_service',
  }

  file { '/usr/local/bin/event_handlers/govuk_app_high_memory.sh':
    source => 'puppet:///modules/govuk/usr/local/bin/event_handlers/govuk_app_high_memory.sh',
    mode   => '0755',
  }

}
