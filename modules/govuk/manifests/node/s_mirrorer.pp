# == Class: Govuk::Node::S_mirrorer
#
#  Node definition for mirrorer boxes
#
# === Parameters:
#
# [*daily_queue_purge*]
#   This purges the rabbitmq queue of all messages. Use with caution!
#
class govuk::node::s_mirrorer inherits govuk::node::s_base {
  include govuk_crawler
  include govuk_rabbitmq
  include nginx

  # FIXME: remove once deployed to Integration
  file { '/root/purge_govuk_crawler_queue.sh':
    ensure => 'absent',
  }

  cron::crondotdee { 'purge_govuk_crawler_queue':
    ensure  => 'absent',
    hour    => 10,
    minute  => 30,
    command => '/root/purge_govuk_crawler_queue.sh',
  }
}
