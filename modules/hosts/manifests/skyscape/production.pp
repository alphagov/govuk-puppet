class hosts::skyscape::production {
  # These are real hosts (1-1 mapping between Host and Service)
  # Anything that ends .cluster is maintained for backwards compatibility with EC2
  #Management VDC machines
  host { 'puppet-1.management.production'  : ip  => '10.0.0.2', host_aliases  => [ 'puppet-1', 'puppet' ] }
  host { 'jenkins-1.management.production' : ip  => '10.0.0.3' }
  host { 'monitoring.management.production' : ip => '10.0.0.20', host_aliases => ['monitoring','monitoring.cluster'] }
  host { 'logging.management.production' : ip    => '10.0.0.21', host_aliases => ['logging','graylog.cluster']}
  host { 'jumpbox-1.management.production' : ip  => '10.0.0.100' }
  host { 'jumpbox-2.management.production' : ip  => '10.0.0.200' }

  #Router VDC machines
  host { 'cache-1.router.production'        : ip => '10.1.0.2' }
  host { 'cache-2.router.production'        : ip => '10.1.0.3' }
  host { 'cache-3.router.production'        : ip => '10.1.0.4' }
  host { 'router-mongo-1.router.production' : ip => '10.1.0.5' }
  host { 'router-mongo-2.router.production' : ip => '10.1.0.6' }
  host { 'router-mongo-3.router.production' : ip => '10.1.0.7' }
  #Load Balancer vhosts
  host { 'cache.cluster.router.production' : ip => '10.1.1.2', host_aliases => ['cache.cluster', 'router.cluster'] }

  #Frontend VDC machines
  host { 'frontend-1.frontend.production'  : ip => '10.2.0.2', host_aliases => ['frontend-1',
                                                                'search.production.alphagov.co.uk' # needed for frontend to call 'rake rummager:index' during deploy
                                                                ] }
  host { 'frontend-2.frontend.production'  : ip => '10.2.0.3' }
  host { 'frontend-3.frontend.production'  : ip => '10.2.0.4' }

  #Backend VDC machines
  host { 'backend-1.backend.production'         : ip => '10.3.0.2', host_aliases => [ 'backend-1', 'signon.production.alphagov.co.uk',
                                                                'panopticon.production.alphagov.co.uk' # needed for panopticon registation
                                                                ]}
  host { 'backend-2.backend.production'         : ip => '10.3.0.3' }
  host { 'backend-3.backend.production'         : ip => '10.3.0.4' }
  host { 'support-1.backend.production'         : ip => '10.3.0.5', host_aliases => [ 'support-1', 'support.cluster']}
  host { 'mongo-1.backend.production'           : ip => '10.3.0.6', host_aliases  => [ 'mongo-1', 'mongo.backend.production', 'mongodb.cluster' ] }
  host { 'mongo-2.backend.production'           : ip => '10.3.0.7' }
  host { 'mongo-3.backend.production'           : ip => '10.3.0.8' }
  host { 'mapit-server-1.backend.production'    : ip => '10.3.0.9', host_aliases => [ 'mapit-server-1', 'mapit.alpha.gov.uk'] }
  host { 'mysql-master-1.backend.production'    : ip => '10.3.10.0', host_aliases => [ 'mysql-master-1', 'mysql.backend.production' ]  }
  #Load Balancer vhosts
  host { 'calendars.cluster.router.production' : ip => '10.2.1.1', host_aliases => ['calendars.cluster', 'calendars.production.alphagov.co.uk'] }
}
