class hosts::scc::production {
  # These are real hosts (1-1 mapping between Host and Service)
  # Anything that ends .cluster is maintained for backwards compatibility with EC2
  # The jumpbox
  host { 'dc2gdsjmp201.gds.internal':       ip => '192.168.228.21',   host_aliases  => [ 'dc2gdsjmp201','jumpbox1' ] }
  # The monitoring box
  host { 'dc2gdsmon201.gds.internal':       ip => '192.168.228.22',  host_aliases   => [ 'dc2gdsmon201','monitoring', 'monitoring.production.internal', 'monitoring.cluster' ] }
  # The puppet master
  host { 'dc2gdsotn201.gds.internal':       ip => '192.168.228.23',  host_aliases   => [ 'dc2gdsotn201', 'dc2gdsptm201.gds.internal', 'puppet', 'puppet.production.internal'] }
}
