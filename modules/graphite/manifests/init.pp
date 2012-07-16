class graphite {
  include graphite::package, graphite::config, graphite::service
  Class['graphite::config'] ~> Class['graphite::service']
}
