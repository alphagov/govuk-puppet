class graphite {
  include graphite::package, graphite::config, graphite::service
  include apache2
  Class['graphite::package'] -> Class['graphite::config'] ~> Class['graphite::service']
  Class['apache2::install'] -> Class['graphite::config'] ~> Class['apache2::service']
}
