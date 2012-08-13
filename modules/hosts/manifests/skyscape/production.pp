class hosts::skyscape::production {
  host { 'puppet':     ip => '10.0.0.6', host_aliases  => 'puppet.prodution.internal' }
  host { 'monitoring': ip => '10.0.0.20', host_aliases => 'monitoring.production.internal' }
}
