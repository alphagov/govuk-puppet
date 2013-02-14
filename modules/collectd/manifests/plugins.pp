# == Class: collectd::plugins
#
# Realise all virtual resources related to collectd plugins. This allows
# other modules to include collect::plugin::* classes without placing a hard
# dependency for nodes that don't run collectd. Unfortunately it means we
# have to list every resource type used.
#
class collectd::plugins {
  Collectd::Plugin  <||>
  File              <| tag == 'collectd::plugin' |>
  Mysql::User       <| tag == 'collectd::plugin' |>
}
