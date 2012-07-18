class hosts::production {
  host { 'static.production.alphagov.co.uk':            ip => '10.250.157.37' } /* production-frontend-2 */
  host { 'fco.production.alphagov.co.uk':               ip => '10.53.54.49' }
  host { 'jobs.production.alphagov.co.uk':              ip => '10.53.54.49' }
  host { 'smartanswers.production.alphagov.co.uk':      ip => '10.53.54.49' }
  host { 'licencefinder.production.alphagov.co.uk':     ip => '10.53.54.49' }
  host { 'designprinciples.production.alphagov.co.uk':  ip => '10.53.54.49' }
  host { 'frontend.production.alphagov.co.uk':          ip => '10.236.86.54' } /* production-frontend-1 */
  host { 'contentapi.production.alphagov.co.uk':        ip => '10.236.86.54' } /* production-frontend-1 */
  host { 'search.production.alphagov.co.uk':            ip => '10.250.157.37' } /* production-frontend-2 */
  host { 'planner.production.alphagov.co.uk':           ip => '10.53.54.49' }
  host { 'calendars.production.alphagov.co.uk':         ip => '10.53.54.49' }
  host { 'tariff.production.alphagov.co.uk':            ip => '10.53.54.49' }
  host { 'tariff-api.production.alphagov.co.uk':        ip => '10.54.182.112' }
  host { 'signon.production.alphagov.co.uk':            ip => '10.54.182.112' }
  host { 'panopticon.production.alphagov.co.uk':        ip => '10.54.182.112' }
  host { 'needotron.production.alphagov.co.uk':         ip => '10.54.182.112' }
  host { 'imminence.production.alphagov.co.uk':         ip => '10.54.182.112' }
  host { 'publisher.production.alphagov.co.uk':         ip => '10.54.182.112' }
  host { 'migratorator.production.alphagov.co.uk':      ip => '10.54.182.112' }
  host { 'reviewomatic.production.alphagov.co.uk':      ip => '10.54.182.112' }
  host { 'private-frontend.production.alphagov.co.uk':  ip => '10.54.182.112' }
  host { 'contactotron.production.alphagov.co.uk':      ip => '10.54.182.112' }
  host { 'whitehall.production.alphagov.co.uk':         ip => '10.224.50.207' }
  host { 'whitehall-search.production.alphagov.co.uk':  ip => '10.224.50.207' }
  host { 'whitehall-admin.production.alphagov.co.uk':   ip => '10.54.182.112' } /* production backend */

  host { 'rds.cluster':         ip => '10.228.229.245' }
  host { 'puppet.cluster':      ip => '10.226.54.244' }

  host { 'frontend.cluster':    ip => '10.53.54.49' }
  host { 'frontend.cluster-1':  ip => '10.236.86.54' }
  host { 'frontend.cluster-2':  ip => '10.250.157.37' }

  host { 'backend.cluster':     ip => '10.54.182.112' }
  host { 'support.cluster':     ip => '10.57.9.177' }
  host { 'data.cluster':        ip => '10.59.3.162' }
  host { 'mysql.cluster':       ip => '10.59.3.162' }
  host { 'mongodb.cluster':     ip => '10.59.3.162' }
  host { 'monitoring.cluster':  ip => '10.58.86.95' }
  host { 'cache.cluster':       ip => '10.51.39.70' }
  host { 'router.cluster':      ip => '10.51.39.70' }
  host { 'graylog.cluster':     ip => '10.234.213.245' }
  host { 'whitehall.cluster':   ip => '10.224.50.207' }

  host { 'designprincipals.production.alphagov.co.uk':
    ensure => absent,
  }
}
