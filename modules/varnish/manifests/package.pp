class varnish::package {
  package { 'varnish':
    ensure => installed
  }
}
