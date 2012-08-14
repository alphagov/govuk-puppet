class hosts::skyscape::production {
  # These are real hosts (1-1 mapping between Host and Service)
  host { 'ip-10-0-0-6.mgmt-sky.internal':  ip => '10.0.0.6',  host_aliases => [ 'ip-10-0-0-6', 'puppet', 'puppet.production.internal' ] }
  host { 'ip-10-0-0-8.mgmt-sky.internal':  ip => '10.0.0.8',  host_aliases => [ 'ip-10-0-0-8', 'jenkins', 'jenkins.production.internal' ] }
  host { 'ip-10-0-0-11.mgmt-sky.internal': ip => '10.0.0.11', host_aliases => [ 'ip-10-0-0-11', 'jumpbox1' ] }
  host { 'ip-10-0-0-12.mgmt-sky.internal': ip => '10.0.0.12', host_aliases => [ 'ip-10-0-0-12', 'jumpbox2' ] }
  host { 'ip-10-0-0-20.mgmt-sky.internal': ip => '10.0.0.20', host_aliases => [ 'ip-10-0-0-20', 'monitoring', 'monitoring.cluster', 'monitoring.production.internal' ] }
}
