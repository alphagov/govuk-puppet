class hosts::skyscape::production {
  # These are Services
  host { 'puppet.production.internal':     ip => '10.0.0.6', host_aliases  => 'puppet' }
  host { 'jenkins.production.internal':    ip => '10.0.0.8', host_aliases  => 'jenkins' }
  host { 'monitoring.production.internal': ip => '10.0.0.20', host_aliases => [ 'monitoring', 'monitoring.cluster'] }
  # These are Hosts:
  host { 'ip-10-0-0-6.mgmt-sky.internal':  ip => '10.0.0.6',  host_aliases => [ 'ip-10-0-0-6' ] }
  host { 'ip-10-0-0-8.mgmt-sky.internal':  ip => '10.0.0.8',  host_aliases => [ 'ip-10-0-0-8' ] }
  host { 'ip-10-0-0-11.mgmt-sky.internal': ip => '10.0.0.11', host_aliases => [ 'ip-10-0-0-11' ] }
  host { 'ip-10-0-0-12.mgmt-sky.internal': ip => '10.0.0.12', host_aliases => [ 'ip-10-0-0-12' ] }
  host { 'ip-10-0-0-20.mgmt-sky.internal': ip => '10.0.0.20', host_aliases => [ 'ip-10-0-0-20' ] }
}
