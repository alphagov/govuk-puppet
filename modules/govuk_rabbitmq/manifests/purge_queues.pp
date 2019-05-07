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
  cron::crondotdee { 'purge_search_api_govuk_index':
    command => '/usr/sbin/rabbitmqctl purge_queue search_api_govuk_index > /dev/null 2>&1',
    hour    => '*',
    minute  => '3',
    user    => 'root',
  }
  cron::crondotdee { 'purge_rummager_govuk_index':
    ensure  => 'absent',
    command => undef,
    hour    => undef,
    minute  => undef,
  }
  cron::crondotdee { 'purge_search_api_to_be_indexed':
    command => '/usr/sbin/rabbitmqctl purge_queue search_api_to_be_indexed > /dev/null 2>&1',
    hour    => '*',
    minute  => '4',
    user    => 'root',
  }
  cron::crondotdee { 'purge_rummager_to_be_indexed':
    ensure  => 'absent',
    command => undef,
    hour    => undef,
    minute  => undef,
  }
}
