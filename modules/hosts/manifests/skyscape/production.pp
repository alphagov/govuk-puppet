class hosts::skyscape::production {
  # These are real hosts (1-1 mapping between Host and Service)
  # Anything that ends .cluster is maintained for backwards compatibility with EC2
  #Management VDC machines
  host { 'puppet-1.management.production'  : ip => '10.0.0.2', host_aliases => [ 'puppet' ] }
  host { 'jenkins-1.management.production' : ip => '10.0.0.3' }

  #Router VDC machines
  host { 'cache-1.router.production'        : ip => '10.1.0.2' }
  host { 'router-mongo-1.router.production' : ip => '10.1.0.5' }

  #Frontend VDC machines
  host { 'frontend-1.frontend.production'  : ip => '10.2.0.2' }

  #Backend VDC machines
  host { 'backend-1.backend.production'         : ip => '10.3.0.2' }
  host { 'backend-2.backend.production'         : ip => '10.3.0.3' }
  host { 'backend-3.backend.production'         : ip => '10.3.0.4' }
  host { 'mysql-master-1.backend.production'    : ip => '10.3.10.0' }
}
