# == Class: icinga::plugin::check_rabbitmq_consumers
#
# Install a Nagios plugin that alerts when a rabbitmq consumer
# has not recieved a heartbeat within the last 5 minutes
#
class icinga::plugin::check_rabbitmq_consumers ($monitoring_password = ''){

  @icinga::plugin { 'check_rabbitmq_consumers':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_rabbitmq_consumers',
  }

  @icinga::nrpe_config { 'check_rabbitmq_consumers':
    content  => template('icinga/etc/nagios/nrpe.d/check_rabbitmq_consumers.cfg.erb'),
  }

  ensure_packages(['python-requests','python-dateutil'])
}
