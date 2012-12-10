class varnish::restart {

  exec { '/etc/init.d/varnish restart':
    refreshonly => true,
  }

}
