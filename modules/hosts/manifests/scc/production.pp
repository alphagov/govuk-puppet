class hosts::scc::production {
  # These are real hosts (1-1 mapping between Host and Service)
  # Anything that ends .cluster is maintained for backwards compatibility with EC2
  host { 'dc2gdsjmp201.gds2.internal':       ip => '192.168.228.23',   host_aliases  => [ 'ip-10-0-0-6', 'puppet', 'puppet.production.internal' ] }
  host { 'dc2gdsjmp201.gds2.internal':       ip => '192.168.228.21',  host_aliases   => [ 'ip-10-0-0-11', 'jumpbox1' ] }
  host { 'dc2gdsmon201.gds2.internal':       ip => '192.168.228.22',  host_aliases   => [ 'ip-10-0-0-20', 'monitoring', 'monitoring.production.internal', 'monitoring.cluster' ] }
}
