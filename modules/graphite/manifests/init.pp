class graphite {
  include graphite::package, graphite::config, graphite::service
  include apache2

  anchor { ['graphite::start', 'graphite::end']: }

  Anchor['graphite::start'] -> Class['graphite::package'] -> Class['graphite::config'] ~> Class['graphite::service'] ~> Anchor['graphite::end']
  Anchor['graphite::start'] ~> Class['graphite::service']

  Class['apache2::package'] -> Class['graphite::config'] ~> Class['apache2::service']
}
