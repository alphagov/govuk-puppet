class hosts::preview {

  $app_domain = extlookup('app_domain')

  host { 'puppet':
    ip           => '10.33.163.224',
    host_aliases => ['puppet.cluster', 'puppetdb.cluster'],
  }
  host { 'rds.cluster':       ip => '10.229.38.255' }
  host { 'frontend.cluster':  ip => '10.58.253.150' }
  host { 'backend.cluster':   ip => '10.228.95.176' }
  host { 'support.cluster':   ip => '10.57.10.89' }
  host { 'data.cluster':      ip => '10.59.61.129' }
  host { 'mysql.cluster':     ip => '10.59.61.129' }
  host { 'mongodb.cluster':   ip => '10.59.61.129' }

  host { "asset-master.${app_domain}":         ip => '10.32.13.47' }
  host { "asset-slave.${app_domain}":          ip => '10.32.14.101' }

  host { 'monitoring.cluster':  ip => '10.51.62.202', host_aliases => ['nagios.cluster','graphite.cluster'] }
  host { 'cache.cluster':       ip => '10.58.175.43' }
  host { 'router.cluster':      ip => '10.58.175.43' }
  host { 'graylog.cluster':     ip => '10.32.31.104' }

  host { "signon.${app_domain}":                  ip => '10.228.95.176' }
  host { "panopticon.${app_domain}":              ip => '10.228.95.176' }
  host { "needotron.${app_domain}":               ip => '10.228.95.176' }
  host { "imminence.${app_domain}":               ip => '10.228.95.176' }
  host { "publisher.${app_domain}":               ip => '10.228.95.176' }
  host { "private-frontend.${app_domain}":        ip => '10.228.95.176' }
  host { "tariff-api.${app_domain}":              ip => '10.228.95.176' }
  host { "contentapi.${app_domain}":              ip => '10.228.95.176' }
  host { "canary-backend.${app_domain}":          ip => '10.228.95.176' }
  host { "travel-advice-publisher.${app_domain}": ip => '10.228.95.176' }
  host { "release.${app_domain}":                 ip => '10.228.95.176' }
  host { "asset-manager.${app_domain}":           ip => '10.228.95.176' }

  host { "search.${app_domain}":                 ip => '10.228.95.176' }
  host { "calendars.${app_domain}":              ip => '10.58.253.150' }
  host { "designprinciples.${app_domain}":       ip => '10.58.253.150' }
  host { "smartanswers.${app_domain}":           ip => '10.58.253.150' }
  host { "licencefinder.${app_domain}":          ip => '10.58.253.150' }
  host { "frontend.${app_domain}":               ip => '10.58.253.150' }
  host { "feedback.${app_domain}":               ip => '10.58.253.150' }
  host { "tariff.${app_domain}":                 ip => '10.58.253.150' }
  host { "efg.${app_domain}":                    ip => '10.58.253.150' }
  host { "migratorator.${app_domain}":           ip => '10.228.95.176' }
  host { "reviewomatic.${app_domain}":           ip => '10.228.95.176' }
  host { "datainsight-frontend.${app_domain}":   ip => '10.58.253.150' }
  host { "canary-frontend.${app_domain}":        ip => '10.58.253.150' }
  host { "transaction-wrappers.${app_domain}":   ip => '10.58.253.150' }
  host { "limelight.${app_domain}":              ip => '10.58.253.150' }

  host { "datainsight-format-success-recorder.${app_domain}":  ip => '10.32.49.43' }
  host { "datainsight-insidegov-recorder.${app_domain}":       ip => '10.32.49.43' }
  host { "datainsight-todays-activity-recorder.${app_domain}": ip => '10.32.49.43' }
  host { "datainsight-weekly-reach-recorder.${app_domain}":    ip => '10.32.49.43' }

  host { "read.backdrop.${app_domain}":         ip => '10.32.49.43' }
  host { "write.backdrop.${app_domain}":        ip => '10.32.49.43' }

  host { "whitehall-frontend.${app_domain}":   ip => '10.49.105.155' }
  host { "whitehall.${app_domain}":            ip => '10.49.105.155' }
  host { 'whitehall.cluster':                           ip => '10.49.105.155' }
  host { "whitehall-admin.${app_domain}":      ip => '10.228.95.176' }


  host { 'licensify-frontend': ip => '10.237.35.45' }
  host { 'licensify-mongo0':   ip => '10.234.74.235' }
  host { 'licensify-mongo1':   ip => '10.229.30.142' }
  host { 'licensify-mongo2':   ip => '10.234.81.24' }
  host { 'places-api':         ip => '10.229.118.175' }
  host { 'ip-10-240-29-155.eu-west-1.compute.internal':
    ip           => '10.240.29.155',
    host_aliases => ['ip-10-240-29-155','mapit',"mapit.${app_domain}",'mapit.production.alphagov.co.uk','mapit.alpha.gov.uk'],
  }
  host { "designprincipals.${app_domain}":
    ensure => absent,
  }
  host { 'ec2-54-247-0-108.eu-west-1.compute.amazonaws.com':
    ip           => '10.238.163.220',
    host_aliases => ['ec2-54-247-0-108.eu-west-1','exception-handler-1'],
  }
}
