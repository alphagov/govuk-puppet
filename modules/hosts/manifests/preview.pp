class hosts::preview {
  host { 'rds.cluster':       ip => '10.229.38.255' }
  host { 'puppet.cluster':    ip => '10.224.103.67' }
  host { 'frontend.cluster':  ip => '10.58.253.150' }
  host { 'backend.cluster':   ip => '10.228.95.176' }
  host { 'support.cluster':   ip => '10.57.10.89' }
  host { 'data.cluster':      ip => '10.59.61.129' }
  host { 'mysql.cluster':     ip => '10.59.61.129' }
  host { 'mongodb.cluster':   ip => '10.59.61.129' }

  host { 'monitoring.cluster':  ip => '10.51.62.202' }
  host { 'cache.cluster':       ip => '10.58.175.43' }
  host { 'router.cluster':      ip => '10.58.175.43' }
  host { 'graylog.cluster':     ip => '10.228.175.48' }

  host { 'signon.preview.alphagov.co.uk':           ip => '10.228.95.176' }
  host { 'panopticon.preview.alphagov.co.uk':       ip => '10.228.95.176' }
  host { 'needotron.preview.alphagov.co.uk':        ip => '10.228.95.176' }
  host { 'imminence.preview.alphagov.co.uk':        ip => '10.228.95.176' }
  host { 'publisher.preview.alphagov.co.uk':        ip => '10.228.95.176' }
  host { 'private-frontend.preview.alphagov.co.uk': ip => '10.228.95.176' }
  host { 'contactotron.preview.alphagov.co.uk':     ip => '10.228.95.176' }
  host { 'tariff-api.preview.alphagov.co.uk':       ip => '10.228.95.176' }
  host { 'search.preview.alphagov.co.uk':           ip => '10.58.253.150' }
  host { 'planner.preview.alphagov.co.uk':          ip => '10.58.253.150' }
  host { 'calendars.preview.alphagov.co.uk':        ip => '10.58.253.150' }
  host { 'designprinciples.preview.alphagov.co.uk': ip => '10.58.253.150' }
  host { 'smartanswers.preview.alphagov.co.uk':     ip => '10.58.253.150' }
  host { 'licencefinder.preview.alphagov.co.uk':    ip => '10.58.253.150' }
  host { 'frontend.preview.alphagov.co.uk':         ip => '10.58.253.150' }
  host { 'contentapi.preview.alphagov.co.uk':       ip => '10.58.253.150' }
  host { 'tariff.preview.alphagov.co.uk':           ip => '10.58.253.150' }
  host { 'efg.preview.alphagov.co.uk':              ip => '10.58.253.150' }
  host { 'migratorator.preview.alphagov.co.uk':     ip => '10.228.95.176' }
  host { 'reviewomatic.preview.alphagov.co.uk':     ip => '10.228.95.176' }

  host { 'whitehall.preview.alphagov.co.uk':        ip => '10.49.105.155' }
  host { 'whitehall-search.preview.alphagov.co.uk': ip => '10.49.105.155' }
  host { 'whitehall.cluster':                       ip => '10.49.105.155' }

  host { 'designprincipals.preview.alphagov.co.uk':
    ensure => absent,
  }
}
