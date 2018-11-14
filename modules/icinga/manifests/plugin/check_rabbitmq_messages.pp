# == Class: icinga::plugin::check_rabbitmq_messages
#
# Install a Nagios plugin that alerts when a rabbitmq queue
# contains more than a given number of messages.
#
class icinga::plugin::check_rabbitmq_messages (
  $warning_threshold   = undef,
  $critical_threshold  = undef,
  $monitoring_password = '',
){

  @icinga::plugin { 'check_rabbitmq_messages':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_rabbitmq_messages',
  }

  @icinga::nrpe_config { 'check_rabbitmq_messages':
    content  => template('icinga/etc/nagios/nrpe.d/check_rabbitmq_messages.cfg.erb'),
  }

  ensure_packages(['python-requests'])
}
