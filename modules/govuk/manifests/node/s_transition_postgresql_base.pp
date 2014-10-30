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

  # FIXME: remove these kernel settings entirely after this has been deployed
  # and tested by rebooting the machines:
  sysctl { 'kernel.shmmax':
    ensure => absent,
    notify => Class['postgresql::server::service']
  }
  sysctl { 'kernel.shmall':
    ensure => absent,
    notify => Class['postgresql::server::service']
  }
}
