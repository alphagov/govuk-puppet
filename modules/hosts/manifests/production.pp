class hosts::production {
  host { 'static.production.alphagov.co.uk':               ip => '10.250.157.37' } /* production-frontend-2 */
  host { 'fco.production.alphagov.co.uk':                  ip => '10.53.54.49' }
  host { 'jobs.production.alphagov.co.uk':                 ip => '10.53.54.49' }
  host { 'smartanswers.production.alphagov.co.uk':         ip => '10.53.54.49' }
  host { 'licencefinder.production.alphagov.co.uk':        ip => '10.53.54.49' }
  host { 'designprinciples.production.alphagov.co.uk':     ip => '10.53.54.49' }
  host { 'frontend.production.alphagov.co.uk':             ip => '10.236.86.54' } /* production-frontend-1 */
  host { 'search.production.alphagov.co.uk':               ip => '10.236.93.237' } /* production-backend-2 */
  host { 'feedback.production.alphagov.co.uk':             ip => '10.53.54.49' }
  host { 'planner.production.alphagov.co.uk':              ip => '10.53.54.49' }
  host { 'calendars.production.alphagov.co.uk':            ip => '10.53.54.49' }
  host { 'tariff.production.alphagov.co.uk':               ip => '10.53.54.49' }
  host { 'tariff-api.production.alphagov.co.uk':           ip => '10.54.182.112' }
  host { 'signon.production.alphagov.co.uk':               ip => '10.54.182.112' }
  host { 'panopticon.production.alphagov.co.uk':           ip => '10.54.182.112' }
  host { 'contentapi.production.alphagov.co.uk':           ip => '10.54.182.112' }
  host { 'needotron.production.alphagov.co.uk':            ip => '10.54.182.112' }
  host { 'imminence.production.alphagov.co.uk':            ip => '10.54.182.112' }
  host { 'publisher.production.alphagov.co.uk':            ip => '10.54.182.112' }
  host { 'migratorator.production.alphagov.co.uk':         ip => '10.54.182.112' }
  host { 'reviewomatic.production.alphagov.co.uk':         ip => '10.54.182.112' }
  host { 'private-frontend.production.alphagov.co.uk':     ip => '10.54.182.112' }
  host { 'whitehall-frontend.production.alphagov.co.uk':   ip => '10.224.50.207' }
  host { 'whitehall.production.alphagov.co.uk':            ip => '10.224.50.207' }
  host { 'whitehall-search.production.alphagov.co.uk':     ip => '10.224.50.207' }
  host { 'whitehall-admin.production.alphagov.co.uk':      ip => '10.54.182.112' } /* production backend */
  host { 'datainsight-frontend.production.alphagov.co.uk': ip => '10.53.54.49' }

  host { 'rds.cluster':         ip => '10.228.229.245' }

  host { 'puppet': ensure => absent }
  host { 'puppet.cluster':
    ip           => '10.32.18.246',
    host_aliases => ['puppet'],
  }
  host { 'ip-10-240-29-155.eu-west-1.compute.internal':
    ip           => '10.240.29.155',
    host_aliases => ['ip-10-240-29-155','mapit','mapit.production.alphagov.co.uk','mapit.alpha.gov.uk'],
  }
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

  host { 'licensify-frontend': ip => '10.229.67.16' }
  host { 'licensify-mongo0':   ip => '10.32.34.170' }
  host { 'licensify-mongo1':   ip => '10.239.11.229' }
  host { 'licensify-mongo2':   ip => '10.32.57.17' }

  host { 'designprincipals.production.alphagov.co.uk':
    ensure => absent,
  }
}
