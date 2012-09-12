class nginx::restart {

  exec { '/etc/init.d/nginx restart':
    refreshonly => true,
    onlyif      => '/etc/init.d/nginx configtest',
  }

}
