class hosts::skyscape::production {
  # These are real hosts (1-1 mapping between Host and Service)
  # Anything that ends .cluster is maintained for backwards compatibility with EC2
  host { 'puppet-1.management.production'  :      ip => '10.0.0.2' }
  host { 'jenkins-1.management.production' :      ip => '10.0.0.3' }
}
