# == Class: govuk::node::s_transition_postgresql_base
#
# Base node for s_transition_postgresql_{master,slave}
#
class govuk::node::s_transition_postgresql_base inherits govuk::node::s_base {
  include govuk::apps::transition::postgresql_db

  Govuk::Mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']

  $effective_cache_size_mb = floor($::memtotalmb * 0.5)
  $shared_buffers_mb       = floor($::memtotalmb * 0.25)

  postgresql::server::config_entry { 'effective_cache_size':
    value => "${$effective_cache_size_mb}MB",
  }
  postgresql::server::config_entry { 'shared_buffers':
    value   => "${$shared_buffers_mb}MB",
    require => Sysctl['kernel.shmmax', 'kernel.shmall'],
  }

  # The calculation given in the following table for the approximate actual
  # requested size for shared_buffers (to use for kernel.shmmax) doesn't give
  # a number big enough for postgresql to be able to restart on a vagrant-govuk
  # box with the default 363MB RAM:
  #
  #     http://www.postgresql.org/docs/9.1/static/kernel-resources.html#SHARED-MEMORY-PARAMETERS
  #
  # Instead, set kernel.shmmax to 120% of shared_buffers, which seems to be
  # big enough (110% wasn't enough when testing with Vagrant):
  $magical_mystery_multiplier = 1.2
  $kernel_shmmax_bytes        = floor($shared_buffers_mb * 1024 * 1024
                                      * $magical_mystery_multiplier)
  # Units for kernel.shmall are pages instead of bytes, and page size as
  # reported by `getconf PAGESIZE` in Preview is 4096. The `ceil` function
  # doesn't exist in Puppet, so use floor + 1 instead.
  $kernel_shmall_pages        = floor($kernel_shmmax_bytes / 4096 ) + 1

  # FIXME: change these kernel settings to `ensure => absent` once we are on
  # PostgreSQL 9.3:
  sysctl { 'kernel.shmmax':
    value  => $kernel_shmmax_bytes,
    notify => Class['postgresql::server::service']
  }
  sysctl { 'kernel.shmall':
    value  => $kernel_shmall_pages,
    notify => Class['postgresql::server::service']
  }
}
