class hosts::skyscape::production {
  # These are real hosts (1-1 mapping between Host and Service)
  # Anything that ends .cluster is maintained for backwards compatibility with EC2
  #Management VDC machines
  host { 'puppet-1.management.production'   : ip  => '10.0.0.2', host_aliases  => [ 'puppet-1', 'puppet' ] }
  host { 'jenkins-1.management.production'  : ip  => '10.0.0.3' }
  host { 'monitoring.management.production' : ip  => '10.0.0.20', host_aliases => ['monitoring','monitoring.cluster'] }
  host { 'logging.management.production'    : ip  => '10.0.0.21', host_aliases => ['logging','graylog.cluster']}
  host { 'jumpbox-1.management.production'  : ip  => '10.0.0.100' }
  host { 'jumpbox-2.management.production'  : ip  => '10.0.0.200' }
  host { 'vcd00003.vpn.skyscapecs.net'      : ip  => '10.202.5.11' }

  #Router VDC machines
  host { 'cache-1.router.production'        : ip => '10.1.0.2' }
  host { 'cache-2.router.production'        : ip => '10.1.0.3' }
  host { 'cache-3.router.production'        : ip => '10.1.0.4' }
  host { 'router-mongo-1.router.production' : ip => '10.1.0.5' }
  host { 'router-mongo-2.router.production' : ip => '10.1.0.6' }
  host { 'router-mongo-3.router.production' : ip => '10.1.0.7' }
  #Load Balancer vhosts
  host { 'cache.router.production' : ip => '10.1.1.1', host_aliases => ['cache', 'cache.cluster', 'router.cluster'] }

  #Frontend VDC machines
  host { 'frontend-1.frontend.production'             : ip => '10.2.0.2', host_aliases => ['frontend-1',
                                                                'tariff.production.alphagov.co.uk',
                                                                'planner.production.alphagov.co.uk',
                                                                'licencefinder.production.alphagov.co.uk',
                                                                'designprinciples.production.alphagov.co.uk',
                                                                'feedback.production.alphagov.co.uk',
                                                                ] }
  host { 'frontend-2.frontend.production'             : ip => '10.2.0.3' }
  host { 'frontend-3.frontend.production'             : ip => '10.2.0.4' }
  host { 'whitehall-frontend-1.frontend.production'   : ip => '10.2.0.5', host_aliases => ['whitehall-frontend-1', 'whitehall-frontend.production.alphagov.co.uk',
                                                                                            'whitehall-search.production.alphagov.co.uk']}
  host { 'whitehall-frontend-2.frontend.production'   : ip => '10.2.0.6', host_aliases => ['whitehall-frontend-2']}
  host { 'elms-frontend-1.frontend.production'        : ip => '10.2.0.7', host_aliases => ['elms-frontend-1']}
  host { 'elms-frontend-2.frontend.production'        : ip => '10.2.0.8', host_aliases => ['elms-frontend-2']}
  #Frontend Load Balancer v
  host { 'calendars.frontend.production'                : ip => '10.2.1.1', host_aliases => ['calendars', 'calendars.production.alphagov.co.uk'] }
  host { 'static.frontend.production'                   : ip => '10.2.1.2', host_aliases => ['static', 'static.production.alphagov.co.uk'] }
  host { 'search.frontend.production'                   : ip => '10.2.1.3', host_aliases => ['search', 'search.production.alphagov.co.uk'] }
  host { 'frontend.frontend.production'                 : ip => '10.2.1.4', host_aliases => ['frontend', 'frontend.production.alphagov.co.uk'] }
  host { 'smartanswers.frontend.production'             : ip => '10.2.1.5', host_aliases => ['smartanswers', 'smartanswers.production.alphagov.co.uk'] }

  #Backend VDC machines
  host { 'backend-1.backend.production'         : ip => '10.3.0.2', host_aliases => [ 'backend-1', 'panopticon.production.alphagov.co.uk' # needed for panopticon registation
                                                                ]}
  host { 'backend-2.backend.production'         : ip => '10.3.0.3' }
  host { 'backend-3.backend.production'         : ip => '10.3.0.4' }
  host { 'support-1.backend.production'         : ip => '10.3.0.5', host_aliases => [ 'support-1', 'support.cluster']}
  host { 'mongo-1.backend.production'           : ip => '10.3.0.6', host_aliases  => [ 'mongo-1', 'mongo.backend.production', 'mongodb.cluster' ] }
  host { 'mongo-2.backend.production'           : ip => '10.3.0.7' }
  host { 'mongo-3.backend.production'           : ip => '10.3.0.8' }
  host { 'mapit-server-1.backend.production'    : ip => '10.3.0.9', host_aliases => [ 'mapit-server-1', 'mapit.alpha.gov.uk'] }
  host { 'mysql-master-1.backend.production'    : ip => '10.3.10.0', host_aliases => [ 'mysql-master-1', 'mysql.backend.production' ]  }
  host { 'elms-backend-1.backend.production'    : ip => '10.3.5.0', host_aliases => ['elms-backend-1', 'licensify-admin.production.alphagov.co.uk']}
  host { 'elms-backend-2.backend.production'    : ip => '10.3.5.1', host_aliases => ['elms-backend-2']}
  host { 'elms-mongo-1.backend.production'      : ip => '10.3.5.3', host_aliases => ['elms-mongo-1']}
  host { 'elms-mongo-2.backend.production'      : ip => '10.3.5.4', host_aliases => ['elms-mongo-2']}
  host { 'elms-mongo-3.backend.production'      : ip => '10.3.5.5', host_aliases => ['elms-mongo-3']}
  #Load Balancer vhosts
  host { 'signon.backend.production'            : ip => '10.3.1.1', host_aliases => ['signon', 'signon.production.alphagov.co.uk'] }

  #EFG machines
  host { 'efg-mysql-master-1.efg.production':
    ip => '10.4.0.10'
  }
  host { 'efg-frontend-1.efg.production':
    ip => '10.4.0.2'
  }
}
