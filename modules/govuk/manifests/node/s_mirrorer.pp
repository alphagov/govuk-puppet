# == Class: Govuk::Node::S_mirrorer
#
#  Node definition for mirrorer boxes
#
# === Parameters:
#
# [*daily_queue_purge*]
#   This purges the rabbitmq queue of all messages. Use with caution!
#
class govuk::node::s_mirrorer (
  $daily_queue_purge = false,
) inherits govuk::node::s_base {
  include govuk_crawler
  include govuk_rabbitmq
  include nginx

  if $daily_queue_purge {
    # Create a file that only root can read so not to expose the rabbitmq root password.
    file { '/root/purge_govuk_crawler_queue.sh':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      content => "/usr/local/bin/rabbitmqadmin --username=root --password=${::govuk_rabbitmq::root_password} purge queue name=govuk_crawler_queue",
      require => Class['govuk_rabbitmq'],
    }

    cron::crondotdee { 'purge_govuk_crawler_queue':
      command => '/root/purge_govuk_crawler_queue.sh',
      hour    => 10,
      minute  => 30,
      mailto  => '""',
      require => File['/root/purge_govuk_crawler_queue.sh'],
    }
  }
}
