class hosts::development {
  host { 'puppet.cluster':      ip => '127.0.0.1' }
  host { 'frontend.cluster':    ip => '127.0.0.1' }
  host { 'backend.cluster':     ip => '127.0.0.1' }
  host { 'support.cluster':     ip => '127.0.0.1' }
  host { 'data.cluster':        ip => '127.0.0.1' }
  host { 'mysql.cluster':       ip => '127.0.0.1' }
  host { 'mongodb.cluster':     ip => '127.0.0.1' }
  host { 'monitoring.cluster':  ip => '127.0.0.1' }
  host { 'cache.cluster':       ip => '127.0.0.1' }
  host { 'router.cluster':      ip => '127.0.0.1' }
  host { 'graylog.cluster':     ip => '127.0.0.1' }
  host { 'whitehall.cluster':   ip => '127.0.0.1' }

  host { 'static.dev.gov.uk':           ip => '127.0.0.1' }
  host { 'smartanswers.dev.gov.uk':     ip => '127.0.0.1' }
  host { 'licencefinder.dev.gov.uk':    ip => '127.0.0.1' }
  host { 'publisher.dev.gov.uk':        ip => '127.0.0.1' }
  host { 'private-frontend.dev.gov.uk': ip => '127.0.0.1' }
  host { 'panopticon.dev.gov.uk':       ip => '127.0.0.1' }
  host { 'needotron.dev.gov.uk':        ip => '127.0.0.1' }
  host { 'imminence.dev.gov.uk':        ip => '127.0.0.1' }
  host { 'contactotron.dev.gov.uk':     ip => '127.0.0.1' }
  host { 'search.dev.gov.uk':           ip => '127.0.0.1' }
  host { 'tariff-api.dev.gov.uk':       ip => '127.0.0.1' }
  host { 'tariff.dev.gov.uk':           ip => '127.0.0.1' }
}
