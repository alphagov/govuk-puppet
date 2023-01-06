# == Class: icinga::plugin::check_amazonmq_consumers
#
# Install a Nagios plugin that alerts when a amazonmq consumer
# has not recieved a heartbeat within the last 5 minutes
#
class icinga::plugin::check_amazonmq_consumers ($monitoring_password = ''){

  @icinga::plugin { 'check_cloudwatch_metric':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_cloudwatch_metric.py',
  }

  @icinga::nrpe_config { 'check_amazonmq_consumers':
    content  => template('icinga/etc/nagios/nrpe.d/check_amazonmq_consumers.cfg.erb'),
  }

  ensure_packages(['python-requests','python-dateutil'])
}
