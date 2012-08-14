class hosts::skyscape::production {
  host { 'puppet.production.internal':     ip => '10.0.0.6', host_aliases  => 'puppet' }
  host { 'monitoring.production.internal': ip => '10.0.0.20', host_aliases => [ 'monitoring', 'monitoring.cluster' ] }
}
