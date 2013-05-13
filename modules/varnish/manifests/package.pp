class varnish::package {
  if $::lsbdistcodename == 'lucid' {
    fail("${title}: Varnish < 3 on Lucid is not supported")
  }

  package { 'varnish':
    ensure => installed
  }
}
