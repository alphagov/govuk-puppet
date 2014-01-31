class nsca::client {
  include nsca

  # FIXME: Remove when deployed to platform1 prod.
  # A horrible thing to remove another horrible thing.
  if !defined(Class['govuk::node::s_monitoring']) {
    service { 'nsca':
      ensure => stopped,
    }
  }
}
