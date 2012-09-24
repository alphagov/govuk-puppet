class hosts::preview {
  host { 'rds.cluster':       ip => '10.229.38.255' }
  host { 'puppet.cluster':    ip => '10.228.138.128' }
  host { 'frontend.cluster':  ip => '10.58.253.150' }
  host { 'backend.cluster':   ip => '10.228.95.176' }
  host { 'support.cluster':   ip => '10.57.10.89' }
  host { 'data.cluster':      ip => '10.59.61.129' }
  host { 'mysql.cluster':     ip => '10.59.61.129' }
  host { 'mongodb.cluster':   ip => '10.59.61.129' }

  host { 'monitoring.cluster':  ip => '10.51.62.202' }
  host { 'cache.cluster':       ip => '10.58.175.43' }
  host { 'router.cluster':      ip => '10.58.175.43' }
  host { 'graylog.cluster':     ip => '10.32.31.104' }

  host { 'signon.preview.alphagov.co.uk':           ip => '10.228.95.176' }
  host { 'panopticon.preview.alphagov.co.uk':       ip => '10.228.95.176' }
  host { 'needotron.preview.alphagov.co.uk':        ip => '10.228.95.176' }
  host { 'imminence.preview.alphagov.co.uk':        ip => '10.228.95.176' }
  host { 'publisher.preview.alphagov.co.uk':        ip => '10.228.95.176' }
  host { 'private-frontend.preview.alphagov.co.uk': ip => '10.228.95.176' }
  host { 'tariff-api.preview.alphagov.co.uk':       ip => '10.228.95.176' }
  host { 'contentapi.preview.alphagov.co.uk':       ip => '10.228.95.176' }

  host { 'search.preview.alphagov.co.uk':               ip => '10.58.253.150' }
  host { 'planner.preview.alphagov.co.uk':              ip => '10.58.253.150' }
  host { 'calendars.preview.alphagov.co.uk':            ip => '10.58.253.150' }
  host { 'designprinciples.preview.alphagov.co.uk':     ip => '10.58.253.150' }
  host { 'smartanswers.preview.alphagov.co.uk':         ip => '10.58.253.150' }
  host { 'licencefinder.preview.alphagov.co.uk':        ip => '10.58.253.150' }
  host { 'frontend.preview.alphagov.co.uk':             ip => '10.58.253.150' }
  host { 'feedback.preview.alphagov.co.uk':             ip => '10.58.253.150' }
  host { 'tariff.preview.alphagov.co.uk':               ip => '10.58.253.150' }
  host { 'efg.preview.alphagov.co.uk':                  ip => '10.58.253.150' }
  host { 'migratorator.preview.alphagov.co.uk':         ip => '10.228.95.176' }
  host { 'reviewomatic.preview.alphagov.co.uk':         ip => '10.228.95.176' }
  host { 'datainsight-frontend.preview.alphagov.co.uk': ip => '10.58.253.150' }

  host { 'whitehall-frontend.preview.alphagov.co.uk':   ip => '10.49.105.155' }
  host { 'whitehall-search.preview.alphagov.co.uk':     ip => '10.49.105.155' }
  host { 'whitehall.preview.alphagov.co.uk':            ip => '10.49.105.155' }
  host { 'whitehall.cluster':                           ip => '10.49.105.155' }
  host { 'whitehall-admin.preview.alphagov.co.uk':      ip => '10.228.95.176' }

  host { 'licensify-frontend': ip => '10.237.35.45' }
  host { 'licensify-mongo0':   ip => '10.234.74.235' }
  host { 'licensify-mongo1':   ip => '10.229.30.142' }
  host { 'licensify-mongo2':   ip => '10.234.81.24' }
  host { 'places-api':         ip => '10.229.118.175' }
  host { 'ip-10-240-29-155.eu-west-1.compute.internal':
    ip           => '10.240.29.155',
    host_aliases => ['ip-10-240-29-155','mapit','mapit.preview.alphagov.co.uk','mapit.production.alphagov.co.uk','mapit.alpha.gov.uk'],
  }
  host { 'designprincipals.preview.alphagov.co.uk':
    ensure => absent,
  }
}
