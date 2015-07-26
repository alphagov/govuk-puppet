# FIXME: Remove this class once it's been deployed to production
class collectd::plugin::search {
  @collectd::plugin { 'search':
    ensure  => absent,
  }
}
