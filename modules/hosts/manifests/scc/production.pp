class hosts::scc::production {
  # These are real hosts (1-1 mapping between Host and Service)
  # Anything that ends .cluster is maintained for backwards compatibility with EC2
  # The jumpbox
  host { 'dc2gdsjmp201.gds.internal':       ip => '192.168.228.21',   host_aliases  => [ 'dc2gdsjmp201','jumpbox1' ] }
  # The monitoring box
  host { 'dc2gdsmon201.gds.internal':       ip => '192.168.228.22',  host_aliases   => [ 'dc2gdsmon201','monitoring', 'monitoring.production.internal', 'monitoring.cluster' ] }
  # The puppet master
  host { 'dc2gdsotn201.gds.internal':       ip => '192.168.228.23',  host_aliases   => [ 'dc2gdsotn201', 'dc2gdsptm201.gds.internal', 'puppet', 'puppet.production.internal'] }
  # The flat sites
  host { 'dc2gdsweb201.gds.internal':       ip => '192.168.228.24',  host_aliases   => [ 'dc2gdsweb201'] }
  host { 'dc2gdsweb202.gds.internal':       ip => '192.168.228.25',  host_aliases   => [ 'dc2gdsweb202'] }
  host { 'dc2gdsweb202.gds.internal':       ip => '192.168.228.26',  host_aliases   => [ 'dc2gdsweb203'] }
}
