class hosts::skyscape::production {
  # These are real hosts (1-1 mapping between Host and Service)
  # Anything that ends .cluster is maintained for backwards compatibility with EC2
  host { 'ip-10-0-0-6.mgmt-sky.internal':       ip => '10.0.0.6',   host_aliases => [ 'ip-10-0-0-6', 'puppet', 'puppet.production.internal' ] }
  host { 'ip-10-0-0-8.mgmt-sky.internal':       ip => '10.0.0.8',   host_aliases => [ 'ip-10-0-0-8', 'jenkins', 'jenkins.production.internal' ] }
  host { 'ip-10-0-0-11.mgmt-sky.internal':      ip => '10.0.0.11',  host_aliases => [ 'ip-10-0-0-11', 'jumpbox1' ] }
  host { 'ip-10-0-0-12.mgmt-sky.internal':      ip => '10.0.0.12',  host_aliases => [ 'ip-10-0-0-12', 'jumpbox2' ] }
  host { 'ip-10-0-0-20.mgmt-sky.internal':      ip => '10.0.0.20',  host_aliases => [ 'ip-10-0-0-20', 'monitoring', 'monitoring.production.internal', 'monitoring.cluster' ] }
  host { 'ip-10-0-0-21.mgmt-sky.internal':      ip => '10.0.0.21',  host_aliases => [ 'ip-10-0-0-21', 'logging', 'logging.production.internal', 'graylog.cluster' ] }

  #TODO: use loadbalanced ip instead
  host { 'ip-10-2-0-2.frontend-sky.internal':   ip => '10.2.0.2',   host_aliases => [ 'ip-10-2-0-2', 'production-frontend', 'search.production.alphagov.co.uk',
                                                                                      'licencefinder.production.alphagov.co.uk'] }
  host { 'ip-10-2-0-3.frontend-sky.internal':   ip => '10.2.0.3',   host_aliases => [ 'ip-10-2-0-3', 'production-frontend-1'] }
  host { 'ip-10-2-0-4.frontend-sky.internal':   ip => '10.2.0.4',   host_aliases => [ 'ip-10-2-0-4', 'production-frontend-2'] }

  #TODO: change router.cluster to load balanced cluster ip
  host { 'ip-10-1-0-3.router-sky.internal':     ip => '10.1.0.3',   host_aliases => [ 'ip-10-1-0-3', 'production-cache'] }
  host { 'ip-10-1-0-4.router-sky.internal':     ip => '10.1.0.4',   host_aliases => [ 'ip-10-1-0-4', 'production-cache-1'] }
  host { 'ip-10-1-0-5.router-sky.internal':     ip => '10.1.0.5',   host_aliases => [ 'ip-10-1-0-5', 'production-cache-2'] }
  host { 'router.cluster':                      ip => '172.16.254.50' }

  #TODO: change panopticon.production to load balanced cluster ip
  host { 'ip-10-3-0-2.backend-sky.internal':    ip => '10.3.0.2',   host_aliases => [ 'production-backend', 'panopticon.production.alphagov.co.uk',
                                                                                      'whitehall-admin.production.alphagov.co.uk'] }
  host { 'ip-10-3-0-3.backend-sky.internal':    ip => '10.3.0.3',   host_aliases => [ 'ip-10-3-0-3', 'production-backend-1'] }
  host { 'ip-10-3-0-4.backend-sky.internal':    ip => '10.3.0.4',   host_aliases => [ 'ip-10-3-0-4', 'production-backend-2'] }
  host { 'ip-10-3-0-5.backend-sky.internal':    ip => '10.3.0.5',   host_aliases => [ 'ip-10-3-0-5', 'production-support', 'support.cluster'] }
  host { 'ip-10-3-0-20.backend-sky.internal':   ip => '10.3.0.20',  host_aliases => [ 'ip-10-3-0-20', 'mapit', 'mapit.alphagov.co.uk'] }
  host { 'ip-10-3-0-6.backend-sky.internal':    ip => '10.3.0.6',   host_aliases => [ 'ip-10-3-0-6', 'mongo-1.production.internal', 'mongo.cluster'] }
  host { 'ip-10-3-0-7.backend-sky.internal':    ip => '10.3.0.7',   host_aliases => [ 'ip-10-3-0-7', 'mongo-2.production.internal'] }
  host { 'ip-10-3-0-8.backend-sky.internal':    ip => '10.3.0.8',   host_aliases => [ 'ip-10-3-0-8', 'mongo-3.production.internal'] }

  host { 'ip-10-3-0-30.backend-sky.internal':   ip => '10.3.0.30',  host_aliases => [ 'ip-10-3-0-30', 'mysql-master', 'mysql-master.production.internal'] }
}
