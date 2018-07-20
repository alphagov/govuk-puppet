# == Define: govuk::app::envvar::memcache_servers
#
# Defines a MEMCACHE_SERVERS environment variable for an app. This
# constructs the value from the given parameters.
#
# === Parameters
#
# [*hosts*]
#   An array of hostnames of the memcache servers.
#
define govuk::app::envvar::memcache_servers (
  $hosts,
) {

  validate_array($hosts)
  if ($hosts == []) {
    fail 'must pass hosts'
  }

  $hosts_string = join($hosts, ',')
  govuk::app::envvar { "${title}-MEMCACHE_SERVERS":
    app     => $title,
    varname => 'MEMCACHE_SERVERS',
    value   => $hosts_string,
  }
}
