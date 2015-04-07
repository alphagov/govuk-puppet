# == Class: govuk_heka::nginx
#
# Consume all Nginx access (JSON) and error (plaintext) entries.
#
# Access entries that have `status` and `request_time` fields will generate
# statsd counters and timers respectively. These are namespaced by Heka's
# `Logger` message variable, which in our case reflects the basename of the
# log file on disk.
#
class govuk_heka::nginx {
  include heka::plugin::json_event_decoder

  # FIXME: Move this to a global config option in heka >=0.9
  if !$::fqdn_underscore {
    fail('Unable to load `fqdn_underscore` fact')
  }

  file { '/usr/share/heka/lua_filters/http_req_stat_filter.lua':
    ensure  => present,
    source  => 'puppet:///modules/govuk_heka/usr/share/heka/lua_filters/http_req_stat_filter.lua',
    notify  => Class['heka::service'],
    require => Class['heka::install'],
  }

  heka::plugin { 'nginx':
    content => template('govuk_heka/etc/heka/nginx.toml.erb'),
  }
}
