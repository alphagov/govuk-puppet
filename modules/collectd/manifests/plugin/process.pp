# == Define: collectd::plugin::process
#
# Collect information about a named process. See collectd documentation for
# more information:
#
# http://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_processes
#
# === Parameters
#
# [*regex*]
#   This will trigger the use of `ProcessMatch` instead of `Process`.
#   Default: ''
#
define collectd::plugin::process(
  $regex = ''
) {
  # Sanitise file and metric names.
  validate_re($title, '^[\w-]+$')

  @collectd::plugin { "process-${title}":
    content => template('collectd/etc/collectd/conf.d/process.conf.erb'),
    require => Collectd::Plugin['processes'],
  }
}
