# == Define: collectd::plugin::process
#
# Collect information about a named process. See collectd documentation for
# more information:
#
# http://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_processes
#
# === Parameters
#
# [*ensure*]
#   Whether the plugin should be present or absent.
#
# [*regex*]
#   This will trigger the use of `ProcessMatch` instead of `Process`.
#   Backslashes will be double escaped for the benefit of collectd's parser.
#   Default: ''
define collectd::plugin::process(
  $ensure = 'present',
  $regex = '',
) {
  # Sanitise file and metric names.
  validate_re($title, '^[\w\-]+$')

  @collectd::plugin { "process-${title}":
    ensure  => $ensure,
    content => template('collectd/etc/collectd/conf.d/process.conf.erb'),
    require => Collectd::Plugin['processes'],
  }
}
