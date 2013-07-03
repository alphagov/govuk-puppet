# == Class: collectd::plugin::processes
#
# This class serves two purposes:
#
# 1. It tells collectd to always monitor basic process stats from a system.
#    Like total number of running, blocked, zombies, etc.
# 2. It ensures that the plugin is loaded before any instances of
#    `collectd::plugin::process` are encountered.
#
class collectd::plugin::processes {
  @collectd::plugin { 'processes':
    prefix  => '00-',
  }
}
