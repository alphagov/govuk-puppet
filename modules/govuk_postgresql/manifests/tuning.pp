# == Class: govuk_postgresql::tuning
#
# Sets the effective_cache_size and shared_buffers to values recommended by the
# postgres documentation
class govuk_postgresql::tuning {
  $effective_cache_size_mb = floor($::memtotalmb * 0.5)
  $shared_buffers_mb       = floor($::memtotalmb * 0.25)

  postgresql::server::config_entry { 'effective_cache_size':
    value => "${$effective_cache_size_mb}MB",
  }
  postgresql::server::config_entry { 'shared_buffers':
    value => "${$shared_buffers_mb}MB",
  }
}
