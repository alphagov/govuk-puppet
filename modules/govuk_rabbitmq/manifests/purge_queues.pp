# == Class: govuk_rabbitmq::purge_queues
#
# Create a cron job to purge rabbitmq queues
#

class govuk_rabbitmq::purge_queues {
  cron::crondotdee { 'purge_content_performance_manager':
    command => '/usr/sbin/rabbitmqctl purge_queue content_performance_manager > /dev/null 2>&1',
    hour    => '*',
    minute  => '0',
    user    => 'root',
  }
}
