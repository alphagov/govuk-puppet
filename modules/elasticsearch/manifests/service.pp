# FIXME: make the service name not depend on $cluster_name
class elasticsearch::service($cluster_name) {

  service { "elasticsearch-${cluster_name}":
    ensure => 'running',
  }

}
