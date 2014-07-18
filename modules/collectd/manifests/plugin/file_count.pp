# == Define: collectd::plugin::file_count
#
# Monitors (recursively) the number of files in a given directory.
#
# === Parameters:
#
# [*directory*]
#   Full path for the directory we want to monitor files for.
#
define collectd::plugin::file_count(
  $directory
) {
  @collectd::plugin { "file count: ${title}":
    content => template('collectd/etc/collectd/conf.d/file_count.conf.erb'),
  }
}
